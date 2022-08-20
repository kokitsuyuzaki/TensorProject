source("src/functions.R")
load("data/objects.RData")

# Parameter
m <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Roading t-test (At)
qtable_at <- c()
load("output/deg/q_at_1d.RData")
qtable_at <- cbind(qtable_at, q)
load("output/deg/q_at_3d.RData")
qtable_at <- cbind(qtable_at, q)
load("output/deg/q_at_7d.RData")
qtable_at <- cbind(qtable_at, q)
load("output/deg/q_at_wol.RData")
qtable_at <- cbind(qtable_at, q)
load("output/deg/q_at_parasm.RData")
qtable_at <- cbind(qtable_at, q)
qtable_at <- apply(qtable_at, 2, function(x){
	# out <- x
	# out[which(x <= 0.1)] <- 1
	# out[which(x > 0.1)] <- 0
	# out
	out <- x
	out[which(rank(x) <= ceiling(0.1 * nrow(qtable_at)))] <- 1
	out[which(rank(x) > ceiling(0.1 * nrow(qtable_at)))] <- 0
	out
})
colnames(qtable_at) <- c("1d", "3d", "7d", "wol", "parasm")

# Roading t-test (Pj)
qtable_pj <- c()
load("output/deg/q_pj_1d.RData")
qtable_pj <- cbind(qtable_pj, q)
load("output/deg/q_pj_3d.RData")
qtable_pj <- cbind(qtable_pj, q)
load("output/deg/q_pj_7d.RData")
qtable_pj <- cbind(qtable_pj, q)
load("output/deg/q_pj_wol.RData")
qtable_pj <- cbind(qtable_pj, q)
load("output/deg/q_pj_parasm.RData")
qtable_pj <- cbind(qtable_pj, q)
qtable_pj <- apply(qtable_pj, 2, function(x){
	# out <- x
	# out[which(x <= 0.1)] <- 1
	# out[which(x > 0.1)] <- 0
	# out
	out <- x
	out[which(rank(x) <= ceiling(0.1 * nrow(qtable_pj)))] <- 1
	out[which(rank(x) > ceiling(0.1 * nrow(qtable_pj)))] <- 0
	out
})
colnames(qtable_pj) <- c("1d", "3d", "7d", "wol", "parasm")

# Roading each method
infile <- paste0("output/", m, ".RData")
load(infile)

# Loading vectors
if(length(grep("guided_pca", m)) != 0){
    loadings_at <- resgPCA_At$u
    loadings_pj <- resgPCA_Pj$u
}
if(length(grep("guided_pls", m)) != 0){
	if(m == "all_guided_pls"){
		loadings_at <- resgPLS$qval1
		loadings_pj <- resgPLS$qval2
	}else{
		loadings_at <- resgPLS$loading1
		loadings_pj <- resgPLS$loading2
	}
}
if(m == "rbh_pls"){
	loadings_at <- scaled_At_logTPM_RBH %*% resgPLS$u[,seq(4)]
	loadings_pj <- scaled_Pj_logTPM_RBH %*% resgPLS$v[,seq(4)]
	rownames(loadings_at) <- rownames(scaled_At_logTPM_RBH)
	rownames(loadings_pj) <- rownames(scaled_Pj_logTPM_RBH)
	# common name (at)
	common_name_at <- intersect(rownames(qtable_at), rownames(loadings_at))
	loadings_at <- loadings_at[common_name_at, ]
	qtable_at <- qtable_at[common_name_at, ]
	# common name (pj)
	common_name_pj <- intersect(rownames(qtable_pj), rownames(loadings_pj))
	loadings_pj <- loadings_pj[common_name_pj, ]
	qtable_pj <- qtable_pj[common_name_pj, ]
}

# Binarization
if(m == "all_guided_pls"){
	loadings_at <- apply(loadings_at, 2, function(x){
		# out <- x
		# out[which(x <= 0.1)] <- 1
		# out[which(x > 0.1)] <- 0
		# out
		out <- x
		out[which(rank(x) <= ceiling(0.1 * nrow(loadings_at)))] <- 1
		out[which(rank(x) > ceiling(0.1 * nrow(loadings_at)))] <- 0
		out
	})
	loadings_pj <- apply(loadings_pj, 2, function(x){
		# out <- x
		# out[which(x <= 0.1)] <- 1
		# out[which(x > 0.1)] <- 0
		# out
		out <- x
		out[which(rank(x) <= ceiling(0.1 * nrow(loadings_pj)))] <- 1
		out[which(rank(x) > ceiling(0.1 * nrow(loadings_pj)))] <- 0
		out
	})
}else{
	loadings_at <- apply(loadings_at, 2, function(x){
		out <- x
		out[which(rank(abs(1/x)) <= ceiling(0.1 * nrow(loadings_at)))] <- 1
		out[which(rank(abs(1/x)) > ceiling(0.1 * nrow(loadings_at)))] <- 0
		out
	})
	loadings_pj <- apply(loadings_pj, 2, function(x){
		out <- x
		out[which(rank(abs(1/x)) <= ceiling(0.1 * nrow(loadings_pj)))] <- 1
		out[which(rank(abs(1/x)) > ceiling(0.1 * nrow(loadings_pj)))] <- 0
		out
	})
}

# Jaccard index (at)
numer_at <- t(qtable_at) %*% loadings_at
denom_at <- outer(colSums(qtable_at), colSums(loadings_at), "+") - numer_at
jaccard_at <- numer_at / denom_at
colnames(jaccard_at) <- paste0("Dim", seq(ncol(jaccard_at)))

# Jaccard index (pj)
numer_pj <- t(qtable_pj) %*% loadings_pj
denom_pj <- outer(colSums(qtable_pj), colSums(loadings_pj), "+") - numer_pj
jaccard_pj <- numer_pj / denom_pj
colnames(jaccard_pj) <- paste0("Dim", seq(ncol(jaccard_pj)))

# Reshape
gdata_at <- melt(jaccard_at)
gdata_pj <- melt(jaccard_pj)
colnames(gdata_at)[3] <- "jaccard"
colnames(gdata_pj)[3] <- "jaccard"
gdata <- rbind(gdata_at, gdata_pj)
gdata <- cbind(gdata,
	c(rep("At", length=nrow(gdata_at)),
		rep("Pj", length=nrow(gdata_at))))
colnames(gdata)[4] <- "species"

# ggplot2
g <- ggplot(gdata, aes(x=Var2, y=Var1, fill = jaccard))
g <- g + geom_tile()
g <- g + facet_wrap(~ species)
g <- g + scale_fill_viridis()
g <- g + theme(text = element_text(size=24))
g <- g + theme(axis.title.x = element_blank())
g <- g + theme(axis.title.y = element_blank())

# Plot
if((length(grep("rbh_", m)) != 0) || (length(grep("all_guided", m)) != 0)){
	ggsave(file=outfile, plot=g, width=15, height=12)
}else{
	ggsave(file=outfile, plot=g, width=15, height=12)
}
