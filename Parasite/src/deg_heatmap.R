source("src/functions.R")
load("data/objects.RData")

# Parameter
m <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

####################################
# Roading DEG (At)
####################################
qtable_at <- c()
experiment <- c("1d", "3d", "7d", "wol", "parasm")
for(i in seq(5)){
	filename <- paste0("output/deg/at_", experiment[i], ".RData")
	load(filename)
	pos_at <- rep(0, length=nrow(deg))
	neg_at <- rep(0, length=nrow(deg))
	names(pos_at) <- rownames(counts_At)
	names(neg_at) <- rownames(counts_At)
	tmp <- deg@.Data[[1]]
	pos <- head(rownames(tmp)[which(tmp$logFC > 0)], 0.1*nrow(counts_At))
	neg <- head(rownames(tmp)[which(tmp$logFC < 0)], 0.1*nrow(counts_At))
	pos_at[pos] <- 1
	neg_at[neg] <- 1
	qtable_at <- cbind(qtable_at, pos_at, neg_at)
}

pos_at <- rep(0, length=nrow(qtable_at))
neg_at <- rep(0, length=nrow(qtable_at))
names(pos_at) <- rownames(counts_At)
names(neg_at) <- rownames(counts_At)
pos <- intersect(procambium_At$GENEID[which(procambium_At$avg_logFC > 0)],
	rownames(qtable_at))
neg <- intersect(procambium_At$GENEID[which(procambium_At$avg_logFC < 0)],
	rownames(qtable_at))
pos <- head(pos, 0.1*nrow(counts_At))
neg <- head(neg, 0.1*nrow(counts_At))
pos_at[pos] <- 1
neg_at[neg] <- 1
qtable_at <- cbind(qtable_at, pos_at, neg_at)
colnames(qtable_at) <- c("1d+", "1d-", "3d+", "3d-", "7d+", "7d-",
	"wol+", "wol-", "parasm+", "parasm-", "procambium+", "procambium-")

####################################
# Roading DEG (Pj)
####################################
qtable_pj <- c()
experiment <- c("1d", "3d", "7d", "wol", "parasm")
for(i in seq(5)){
	filename <- paste0("output/deg/pj_", experiment[i], ".RData")
	load(filename)
	pos_pj <- rep(0, length=nrow(deg))
	neg_pj <- rep(0, length=nrow(deg))
	names(pos_pj) <- rownames(counts_Pj)
	names(neg_pj) <- rownames(counts_Pj)
	tmp <- deg@.Data[[1]]
	pos <- head(rownames(tmp)[which(tmp$logFC > 0)], 0.1*nrow(counts_Pj))
	neg <- head(rownames(tmp)[which(tmp$logFC < 0)], 0.1*nrow(counts_Pj))
	pos_pj[pos] <- 1
	neg_pj[neg] <- 1
	qtable_pj <- cbind(qtable_pj, pos_pj, neg_pj)
}

pos_pj <- rep(0, length=nrow(qtable_pj))
neg_pj <- rep(0, length=nrow(qtable_pj))
names(pos_pj) <- rownames(counts_Pj)
names(neg_pj) <- rownames(counts_Pj)
pos <- intersect(procambium_Pj$GENEID[which(procambium_Pj$avg_logFC > 0)],
	rownames(qtable_pj))
neg <- intersect(procambium_Pj$GENEID[which(procambium_Pj$avg_logFC < 0)],
	rownames(qtable_pj))
pos <- head(pos, 0.1*nrow(counts_Pj))
neg <- head(neg, 0.1*nrow(counts_Pj))
pos_pj[pos] <- 1
neg_pj[neg] <- 1
qtable_pj <- cbind(qtable_pj, pos_pj, neg_pj)
colnames(qtable_pj) <- c("1d+", "1d-", "3d+", "3d-", "7d+", "7d-",
	"wol+", "wol-", "parasm+", "parasm-", "procambium+", "procambium-")

####################################
# Roading each method
####################################
infile <- paste0("output/", m, ".RData")
load(infile)

# Raw Loading vectors
if(length(grep("guided_pca", m)) != 0){
    loadings_at <- resgPCA_At$u
    loadings_pj <- resgPCA_Pj$u
}
if(length(grep("guided_pls", m)) != 0){
	if(m == "all_guided_pls"){
		# loadings_at <- resgPLS$qval1
		# loadings_pj <- resgPLS$qval2
		loadings_at <- resgPLS$loading1
		loadings_pj <- resgPLS$loading2
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

####################################
# Positive/Negative
####################################
loadings_at <- loadings_at[, unlist(lapply(seq(ncol(loadings_at)), function(x){rep(x, 2)}))]
loadings_pj <- loadings_pj[, unlist(lapply(seq(ncol(loadings_pj)), function(x){rep(x, 2)}))]
for(i in seq(ncol(loadings_at))){
	if(i %% 2 == 1){
		loadings_at[,i] <- - loadings_at[,i]
		loadings_pj[,i] <- - loadings_pj[,i]
	}
}

colnames(loadings_at) <- unlist(lapply(seq(ncol(loadings_at)/2),
	function(x){paste0("Dim", x, c("+", "-"))}))
colnames(loadings_pj) <- unlist(lapply(seq(ncol(loadings_pj)/2),
	function(x){paste0("Dim", x, c("+", "-"))}))

####################################
# Binarization
####################################
if(m == "all_guided_pls"){
	loadings_at <- apply(loadings_at, 2, function(x){
		# out <- x
		# out[which(x <= 0.1)] <- 1
		# out[which(x > 0.1)] <- 0
		# out
		out <- x
		out[which(rank(x) <= 0.1*nrow(loadings_at))] <- 1
		out[which(rank(x) > 0.1*nrow(loadings_at))] <- 0
		out
	})
	loadings_pj <- apply(loadings_pj, 2, function(x){
		# out <- x
		# out[which(x <= 0.1)] <- 1
		# out[which(x > 0.1)] <- 0
		# out
		out <- x
		out[which(rank(x) <= 0.1*nrow(loadings_pj))] <- 1
		out[which(rank(x) > 0.1*nrow(loadings_pj))] <- 0
		out
	})
}else{
	loadings_at <- apply(loadings_at, 2, function(x){
		out <- x
		out[which(rank(abs(1/x)) <= 0.1*nrow(loadings_at))] <- 1
		out[which(rank(abs(1/x)) > 0.1*nrow(loadings_at))] <- 0
		out
	})
	loadings_pj <- apply(loadings_pj, 2, function(x){
		out <- x
		out[which(rank(abs(1/x)) <= 0.1*nrow(loadings_pj))] <- 1
		out[which(rank(abs(1/x)) > 0.1*nrow(loadings_pj))] <- 0
		out
	})
}


####################################
# Jaccard index
####################################
# Jaccard index (at)
numer_at <- t(qtable_at) %*% loadings_at
denom_at <- outer(colSums(qtable_at), colSums(loadings_at), "+") - numer_at
jaccard_at <- numer_at / denom_at

# Jaccard index (pj)
numer_pj <- t(qtable_pj) %*% loadings_pj
denom_pj <- outer(colSums(qtable_pj), colSums(loadings_pj), "+") - numer_pj
jaccard_pj <- numer_pj / denom_pj

####################################
# Plot Heatmap
####################################
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
g <- g + theme(axis.text.x = element_text(size=18, angle=90, hjust=1))

# Plot
if((length(grep("rbh_", m)) != 0) || (length(grep("all_guided", m)) != 0)){
	ggsave(file=outfile, plot=g, width=15, height=12)
}else{
	ggsave(file=outfile, plot=g, width=15, height=12)
}
