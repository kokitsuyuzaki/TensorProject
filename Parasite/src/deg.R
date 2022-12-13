source("src/functions.R")
load("data/objects.RData")

# Parameter
species <- commandArgs(trailingOnly=TRUE)[1]
degs <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Preprocessing
if(species == "at"){
	counts <- counts_At
}
if(species == "pj"){
	counts <- counts_Pj
}

# Group Index
# At
if((species == "at") && (degs == "1d")){
	index1 <- which(Y_At_time[,1] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}
if((species == "at") && (degs == "3d")){
	index1 <- which(Y_At_time[,2] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}
if((species == "at") && (degs == "7d")){
	index1 <- which(Y_At_time[,3] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}
if((species == "at") && (degs == "wol")){
	index1 <- which(Y_At_wol[,1] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}
if((species == "at") && (degs == "parasm")){
	index1 <- which(Y_At_parasm[,1] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}

# Pj
if((species == "pj") && (degs == "1d")){
	index1 <- which(Y_Pj_time[,1] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}
if((species == "pj") && (degs == "3d")){
	index1 <- which(Y_Pj_time[,2] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}
if((species == "pj") && (degs == "7d")){
	index1 <- which(Y_Pj_time[,3] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}
if((species == "pj") && (degs == "wol")){
	index1 <- which(Y_Pj_wol[,1] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}
if((species == "pj") && (degs == "parasm")){
	index1 <- which(Y_Pj_parasm[,1] == 1)
	index2 <- setdiff(seq(ncol(counts)), index1)
}

# edgeR
group <- rep("A", length=ncol(counts))
group[index1] <- "B"
group <- factor(group)
design <- model.matrix(~ group)
d <- DGEList(counts = counts, group = group)
d <- calcNormFactors(d)
d <- estimateDisp(d, design)
fit <- glmFit(d, design)
lrt <- glmLRT(fit, coef = 2)
deg <- topTags(lrt, n=nrow(lrt))

# Save
save(deg, file=outfile)
