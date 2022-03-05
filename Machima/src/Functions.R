library("MASS")
library("mwTensor")
library("nnTensor")
library("fields")
library("igraph")
library("bindSC")

# pseudocount=1e-10
# J=5
# thr=1e-10
# viz = TRUE
# figdir="BijNMF"
# init="NMF"
# num.iter=30
# verbose=TRUE

# Frobenius: Beta=2
# KL: Beta=1
# IS: Beta=0
BijNMF <- function(X_RNA, X_Epi, pseudocount=1e-10, J=5, Alpha=0.5,
	Beta=2, thr=1e-10, viz=FALSE, figdir=NULL,
	init = c("NMF", "Random"),
	num.iter=30, verbose=FALSE){
	# Argument Check
	init <- match.arg(init)
	.checkBijNMF(X_RNA, X_Epi, pseudocount, J, Beta, thr,
		viz, figdir, num.iter, verbose)
	# Initialization
	int <- .initBijNMF(X_RNA, X_Epi, pseudocount, J, init)
	X_RNA <- int$X_RNA
	X_Epi <- int$X_Epi
	W_RG <- int$W_RG
	H_RNA <- int$H_RNA
	W_Epi <- int$W_Epi
	H_EG <- int$H_EG
	X_GAM_0 <- int$X_GAM_0
	X_GAM_L <- X_GAM_0
	X_GAM_R <- NULL
	# Before Update
	if(viz && !is.null(figdir)){
		png(filename = paste0(figdir, "/0.png"),
			width=2500, height=500)
		.multiImagePlots(list(X_RNA, X_GAM_0, X_GAM_0, X_Epi))
		dev.off()
	}
	if(viz && is.null(figdir)){
		.multiImagePlots(list(X_RNA, X_GAM_0, X_GAM_0, X_Epi))
	}
	# Iteration
	iter <- 1
	while (iter <= num.iter){
		# Step1: Update W_RG
		W_RG <- .updateW_RG(X_RNA, W_RG, H_RNA, H_EG, X_GAM_L, Beta)
		# Step2: Update H_RNA
		H_RNA <- .updateH_RNA(X_RNA, W_RG, H_RNA, Beta)
		# Step3: Update X_GAM_L
		X_GAM_L <- .updateX_GAM(W_RG, H_EG)
		X_GAM_R <- (1 - Alpha) * X_GAM_0 + Alpha * X_GAM_L
		# Step4: Update W_Epi
		W_Epi <- .updateW_Epi(X_Epi, W_Epi, H_EG, Beta)
		# Step5: Update H_EG
		H_EG <- .updateH_EG(X_Epi, W_RG, W_Epi, H_EG, X_GAM_R, Beta)
		# Step6: Update X_GAM_R
		X_GAM_R <- .updateX_GAM(W_RG, H_EG)
		X_GAM_L <- (1 - Alpha) * X_GAM_0 + Alpha * X_GAM_R
		# After Update
		if(viz && !is.null(figdir)){
			png(filename = paste0(figdir, "/", iter, ".png"),
				width=2500, height=500)
			.multiImagePlots(list(X_RNA, X_GAM_L, X_GAM_R, X_Epi))
			dev.off()
		}
		if(viz && is.null(figdir)){
			.multiImagePlots(list(X_RNA, X_GAM_L, X_GAM_R, X_Epi))
		}
		if(verbose){
			cat(paste0(iter, " / ", num.iter, "\n"))
		}
		iter <- iter + 1
	}
	# Output
	list(W_RG=W_RG, H_RNA=H_RNA,
		W_Epi=W_Epi, H_EG=H_EG,
		X_GAM_0=X_GAM_0, X_GAM_L=X_GAM_L, X_GAM_R=X_GAM_R)
}

# Check
.checkBijNMF <- function(X_RNA, X_Epi, pseudocount, J, Beta, thr,
		viz, figdir, num.iter, verbose){
	# Check Pseudo-count
	stopifnot(pseudocount >= 0)
	# Check J
	stopifnot(J <= min(dim(X_RNA), dim(X_Epi)))
	# Check Beta
	stopifnot(Beta >= 0)
	# Check thr
	stopifnot(thr >= 0)
	# viz
	stopifnot(is.logical(viz))
	# Check figdir
	if(!is.character(figdir) && !is.null(figdir)){
		stop("Please specify the figdir as a string or NULL")
	}
	# Check num.iter
	stopifnot(num.iter >= 0)
	# Check verbose
	stopifnot(is.logical(verbose))
}

.reArrangeCols <- function(A, oldA){
    if(ncol(A) == 1){
        A
    }else{
        cor.matrix <- cor(A, oldA)
        cols <- paste0("Col", seq(ncol(A)))
        colnames(cor.matrix) <- cols
        rownames(cor.matrix) <- seq(ncol(A))
        g <- graph_from_incidence_matrix(cor.matrix, weighted=TRUE)
        index <- as.numeric(as.vector(max_bipartite_match(g)$matching[cols]))
        A[, index]
    }
}

.reArrangeRows <- function(A, oldA){
    if(nrow(A) == 1){
        A
    }else{
        cor.matrix <- cor(t(A), t(oldA))
        abs.cor.matrix <- abs(cor(t(A), t(oldA)))
        abs.cor.matrix[which(is.na(abs.cor.matrix))] <- 0
        rows <- paste0("Row", seq(nrow(A)))
        rownames(abs.cor.matrix) <- rows
        colnames(abs.cor.matrix) <- seq(nrow(A))
        g <- graph_from_incidence_matrix(abs.cor.matrix, weighted=TRUE)
        index <- as.numeric(as.vector(max_bipartite_match(g)$matching[rows]))
        # Flip sign
        A[index, ] * sign(cor.matrix[cbind(seq(nrow(A)), index)])
    }
}

.normalizeCols <- function(A){
	normA <- apply(A, 2, function(a){norm(as.matrix(a), "F")})	
	A <- t(t(A) / normA)
	list(A=A, normA=normA)
}

.normalizeRows <- function(A){
	normA <- apply(A, 1, function(a){norm(as.matrix(a), "F")})	
	A <- A / normA	
	list(A=A, normA=normA)
}

.reArrangeOuts <- function(out, X){
    normU <- apply(out$U, 2, function(x){norm(as.matrix(x), "F")})
    normV <- apply(out$V, 2, function(x){norm(as.matrix(x), "F")})
    orderNorm <- order(normU * normV, decreasing=TRUE)
    out$U <- out$U[, orderNorm]
    out$V <- out$V[, orderNorm]
    out
}

.returnBestNMF <- function(X, J){
	outs <- lapply(seq(1), function(x){
		NMF(X, J=J, num.iter=30, algorithm="Frobenius")
	})
	bestfit <- unlist(lapply(outs, function(x){rev(x$RecError)[1]}))
	bestfit <- which(bestfit == min(bestfit))[1]
	outs[[bestfit]]
}

# Initialization: W_RG, H_RNA, W_Epi, H_EG, X_GAM_0
.initBijNMF <- function(X_RNA, X_Epi, pseudocount, J, init){
	X_RNA[which(X_RNA == 0)] <- pseudocount
	X_Epi[which(X_Epi == 0)] <- pseudocount
	if(init == "NMF"){
		out1_1 <- .reArrangeOuts(.returnBestNMF(X_RNA, J=J), X_RNA)
		out1_2 <- .normalizeCols(out1_1$U)
		W_RG <- out1_2$A
		H_RNA <- t(out1_1$V) / out1_2$normA
		out2_1 <- .reArrangeOuts(.returnBestNMF(X_Epi, J=J), X_Epi)
		out2_2 <- .normalizeCols(out2_1$V)
		W_Epi <- t(t(out2_1$U) / out2_2$normA)
		H_EG <- t(out2_2$A)
		X_GAM_0 <- .updateX_GAM(W_RG, H_EG)
	}
	if(init == "Random"){
		W_RG <- .normalizeCols(
			matrix(runif(nrow(X_RNA)*J),
			nrow=nrow(X_RNA), ncol=J))$A
		H_RNA <- t(W_RG) %*% X_RNA
		H_EG <- .normalizeRows(
			matrix(runif(J*ncol(X_Epi)),
			nrow=J, ncol=ncol(X_Epi)))$A
		W_Epi <- X_Epi %*% t(H_EG)
		X_GAM_0 <- .updateX_GAM(W_RG, H_EG)
	}
	list(X_RNA=X_RNA, X_Epi=X_Epi,
		W_RG=W_RG, H_RNA=H_RNA, W_Epi=W_Epi, H_EG=H_EG,
		X_GAM_0=X_GAM_0)
}

# Step1: Update W_RG
.updateW_RG <- function(X_RNA, W_RG, H_RNA, H_EG, X_GAM_L, Beta){
	oldW_RG <- W_RG
	numer1 <- (((W_RG %*% H_RNA)^(Beta - 2) * X_RNA) %*% t(H_RNA))
	denom1 <- ((W_RG %*% H_RNA)^(Beta - 1) %*% t(H_RNA))
	numer2 <- (((W_RG %*% H_EG)^(Beta - 2) * X_GAM_L) %*% t(H_EG))
	denom2 <- ((W_RG %*% H_EG)^(Beta - 1) %*% t(H_EG))
	W_RG <- W_RG * ((numer1 / denom1) + (numer2 / denom2))
	W_RG <- .reArrangeCols(W_RG, oldW_RG)
	.normalizeCols(W_RG)$A
}

# Step2: Update H_RNA
.updateH_RNA <- function(X_RNA, W_RG, H_RNA, Beta){
	oldH_RNA <- H_RNA
	numer1 <- t(t((W_RG %*% H_RNA)^(Beta - 2) * X_RNA) %*% W_RG)
	denom1 <- t(t((W_RG %*% H_RNA)^(Beta - 1)) %*% W_RG)
	H_RNA <- H_RNA * (numer1 / denom1)
	.reArrangeRows(H_RNA, oldH_RNA)
}

# Step3/6: Update X_GAM
.updateX_GAM <- function(W_RG, H_EG){
	W_RG %*% H_EG
}

# Step4: Update W_Epi
.updateW_Epi <- function(X_Epi, W_Epi, H_EG, Beta){
	oldW_Epi <- W_Epi
	numer1 <- (((W_Epi %*% H_EG)^(Beta - 2) * X_Epi) %*% t(H_EG))
	denom1 <- ((W_Epi %*% H_EG)^(Beta - 1) %*% t(H_EG))
	W_Epi <- W_Epi * (numer1 / denom1)
	.reArrangeCols(W_Epi, oldW_Epi)
}

# Step5: Update H_EG
.updateH_EG <- function(X_Epi, W_RG, W_Epi, H_EG, X_GAM_R, Beta){
	oldH_EG <- H_EG
	numer1 <- t(t((W_RG %*% H_EG)^(Beta - 2) * X_GAM_R) %*% W_RG)
	denom1 <- t(t((W_RG %*% H_EG)^(Beta - 1)) %*% W_RG)
	numer2 <- t(t((W_Epi %*% H_EG)^(Beta - 2) * X_Epi) %*% W_Epi)
	denom2 <- t(t((W_Epi %*% H_EG)^(Beta - 1)) %*% W_Epi)
	H_EG <- H_EG * ((numer1 / denom1) + (numer2 / denom2))
	H_EG <- .reArrangeRows(H_EG, oldH_EG)
	.normalizeRows(H_EG)$A
}

.multiImagePlots <- function(inputList){
	layout(t(1:4))
	image.plot(inputList[[1]])
	image.plot(inputList[[2]])
	image.plot(inputList[[3]])
	image.plot(inputList[[4]])
}