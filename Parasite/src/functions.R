library("einsum")
library("rTensor")
library("mwTensor")
library("nnTensor")
library("edgeR")
library("CCA")
library("Rtsne")
library("ggplot2")
library("RColorBrewer")
library("geigen")

####################################
# Setting for guided PLS
####################################
guidedPLS <- function(X1, X2, Y1, Y2, sgnX=NULL, sgnY=NULL){
    # guided PLS
    res <- svd(t(X1) %*% Y1 %*% t(Y2) %*% X2)
    # Loading
    loading1 <- res$u[,seq(2)]
    loading2 <- res$v[,seq(2)]
    # Score
    score1 <- X1 %*% loading1
    score2 <- X2 %*% loading2
    # Output
    list(res=res, loading1=loading1, loading2=loading2,
        score1=score1, score2=score2)
}

####################################
# Setting for guided CCA
####################################
guidedCCA <- function(X1, X2, Y1, Y2, sgnX=NULL, sgnY=NULL, lambda1=0, lambda2=0){
	# guided PCA
    res_svd1 <- svd(t(X1) %*% Y1)
    res_svd2 <- svd(t(X2) %*% Y2)
    if(!is.null(sgnX)){
    	res_svd1 <- .flipSignSVD(res_svd1, sgnX)
    }
    if(!is.null(sgnY)){
    	res_svd2 <- .flipSignSVD(res_svd2, sgnY)
    }
    # CCA
    Z1 <- res_svd1$u
    Z2 <- res_svd2$u
    res_cca <- rcc(Z1, Z2, lambda1, lambda2)
    # Diagonal matrix
    dmat1 <- matrix(0, nrow=length(res_svd1$d), ncol=length(res_svd1$d))
    dmat2 <- matrix(0, nrow=length(res_svd2$d), ncol=length(res_svd2$d))
    diag(dmat1) <- 1 / res_svd1$d
    diag(dmat2) <- 1 / res_svd2$d
    # Loading
    loading1 <- res_cca$scores$xscores
    loading2 <- res_cca$scores$yscores
    # Score
    score1 <- X1 %*% t(ginv(loading1))
    score2 <- X2 %*% t(ginv(loading2))
    # Output
    list(res_svd1=res_svd1, res_svd2=res_svd2, res_cca=res_cca,
        score1=score1, score2=score2, loading1=loading1, loading2=loading2)
}

.flipSignSVD <- function(res, sgn){
    for(i in seq_along(sgn)){
	    res$u[,i] <- res$u[,i] * sgn[i]
	    res$v[,i] <- res$v[,i] * sgn[i]
    }
    res
}

####################################
# Setting for Plot
####################################
colorAt <- c(
	# 1d: red
	rgb(1,0,0), # wt root
	brewer.pal(8, "Dark2")[4], # wol root
	brewer.pal(8, "Dark2")[2], # wt w Pj
	brewer.pal(8, "Accent")[3], # wol w Pj
	# 3d: green
	rgb(0,1,0), # wt root
	brewer.pal(8, "Dark2")[1], # wol root
	brewer.pal(8, "Dark2")[5], # wt w Pj
	brewer.pal(8, "Accent")[1], # wol w Pj
	# 7d: blue
	rgb(0,0,1), # wt root
	brewer.pal(8, "Dark2")[3], # wol root
	brewer.pal(8, "Accent")[2], # wt w Pj
	brewer.pal(8, "Accent")[5] # wol w Pj
)
names(colorAt) <- c(
	# 1d: red
    "At_wt_root_1d",
    "At_wol_root_1d",
    "At_wt_1d",
    "At_wol_1d",
	# 3d: green
    "At_wt_root_3d",
    "At_wol_root_3d",
    "At_wt_3d",
    "At_wol_3d",
	# 7d: blue
    "At_wt_root_7d",
    "At_wol_root_7d",
    "At_wt_7d",
    "At_wol_7d")

colorPj <- c(
	# 1d: red
	rgb(1,0,0), # wt root
	brewer.pal(8, "Dark2")[2], # wt w Pj
	brewer.pal(8, "Accent")[3], # wol w Pj
	# 3d: green
	rgb(0,1,0), # wt root
	brewer.pal(8, "Dark2")[5], # wt w Pj
	brewer.pal(8, "Accent")[1], # wol w Pj
	# 7d: blue
	rgb(0,0,1), # wt root
	brewer.pal(8, "Accent")[2], # wt w Pj
	brewer.pal(8, "Accent")[5] # wol w Pj
)
names(colorPj) <- c(
	# 1d: red
    "Pj_root_1d",
    "Pj_wt_1d",
    "Pj_wol_1d",
	# 3d: green
    "Pj_root_3d",
    "Pj_wt_3d",
    "Pj_wol_3d",
	# 7d: blue
    "Pj_root_7d",
    "Pj_wt_7d",
    "Pj_wol_7d")
