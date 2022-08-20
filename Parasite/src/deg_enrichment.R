source("src/functions.R")
load("data/objects.RData")

# Parameter
m <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Roading each method
infile <- paste0("output/", m, ".RData")
load(infile)

# Loading vectors
if(length(grep("guided_pca", m)) != 0){
    loadings_at <- resgPCA_At$u
    loadings_pj <- resgPCA_Pj$u
}
if(length(grep("guided_pls", m)) != 0){
	loadings_at <- resgPLS$loading1
	loadings_pj <- resgPLS$loading2
}

# Binarization (Positive)
loadings_at_pos <- apply(loadings_at, 2, function(x){
	out <- x
	out[which(rank(-x) <= 500)] <- 1
	out[which(rank(-x) > 500)] <- 0
	out
})

# Binarization (Positive)
loadings_pj_pos <- apply(loadings_pj, 2, function(x){
	out <- x
	out[which(rank(-x) <= 500)] <- 1
	out[which(rank(-x) > 500)] <- 0
	out
})

# Binarization (Negative)
loadings_at_neg <- apply(loadings_at, 2, function(x){
	out <- x
	out[which(rank(x) <= 500)] <- 1
	out[which(rank(x) > 500)] <- 0
	out
})

# Binarization (Negative)
loadings_pj_neg <- apply(loadings_pj, 2, function(x){
	out <- x
	out[which(rank(x) <= 500)] <- 1
	out[which(rank(x) > 500)] <- 0
	out
})

# Output directory
dir.create(paste0("output/enrichment/", m), recursive=TRUE)

# Enrichment Analysis Setting
GOType <- c("BP", "MF", "CC")

# Enrichment Analysis (At)
GOList_At <- list(At_GO_BP, At_GO_MF, At_GO_CC)
for(i in seq(ncol(loadings_at))){
	for(j in seq(3)){
		outGO_pos <- .EnrichLoadings(loadings_at_pos[,i], GOList_At[[j]], scaled_At_logTPM, 0.1)
		outGO_neg <- .EnrichLoadings(loadings_at_neg[,i], GOList_At[[j]], scaled_At_logTPM, 0.1)
		outfileGO_pos <- paste0("output/enrichment/", m, "/At_", GOType[j], "_pos", i, ".txt")
		outfileGO_neg <- paste0("output/enrichment/", m, "/At_", GOType[j], "_neg", i, ".txt")
		# Save
		write.table(outGO_pos, outfileGO_pos, quote=FALSE, row.names=FALSE, sep="\t")
		write.table(outGO_neg, outfileGO_neg, quote=FALSE, row.names=FALSE, sep="\t")
	}
}

# Enrichment Analysis (Pj)
GOList_Pj <- list(Pj_GO_BP, Pj_GO_MF, Pj_GO_CC)
for(i in seq(ncol(loadings_pj))){
	for(j in seq(3)){
		outGO_pos <- .EnrichLoadings(loadings_pj_pos[,i], GOList_Pj[[j]], scaled_Pj_logTPM, 0.1)
		outGO_neg <- .EnrichLoadings(loadings_pj_neg[,i], GOList_Pj[[j]], scaled_Pj_logTPM, 0.1)
		outfileGO_pos <- paste0("output/enrichment/", m, "/Pj_", GOType[j], "_pos", i, ".txt")
		outfileGO_neg <- paste0("output/enrichment/", m, "/Pj_", GOType[j], "_neg", i, ".txt")
		# Save
		write.table(outGO_pos, outfileGO_pos, quote=FALSE, row.names=FALSE, sep="\t")
		write.table(outGO_neg, outfileGO_neg, quote=FALSE, row.names=FALSE, sep="\t")
	}
}

# Output
file.create(outfile)
