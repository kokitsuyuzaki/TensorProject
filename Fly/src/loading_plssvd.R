source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile1 <- args[3]
outfile2 <- args[4]
outfile3 <- args[5]
outfile4 <- args[6]

# Load
load(infile1)
load(infile2)

allgene1 <- data.frame(genename=rownames(count),
	loading=res.plssvd$loadingX[,1])
allgene2 <- data.frame(genename=rownames(count),
	loading=res.plssvd$loadingX[,2])
allgene3 <- data.frame(genename=rownames(count),
	loading=res.plssvd$loadingX[,3])
allgene4 <- data.frame(genename=rownames(count),
	loading=res.plssvd$loadingX[,4])

rownames(allgene1) <- NULL
rownames(allgene2) <- NULL
rownames(allgene3) <- NULL
rownames(allgene4) <- NULL

deggene1 <- allgene1[which(rank(1/abs(res.plssvd$loadingX[, 1])) <= 100), ]
deggene2 <- allgene2[which(rank(1/abs(res.plssvd$loadingX[, 2])) <= 100), ]
deggene3 <- allgene3[which(rank(1/abs(res.plssvd$loadingX[, 3])) <= 100), ]
deggene4 <- allgene4[which(rank(1/abs(res.plssvd$loadingX[, 4])) <= 100), ]

deg1 <- list(allgene=allgene1, deg=deggene1)
deg2 <- list(allgene=allgene2, deg=deggene2)
deg3 <- list(allgene=allgene3, deg=deggene3)
deg4 <- list(allgene=allgene4, deg=deggene4)

# Save
write_xlsx(deg1, outfile1)
write_xlsx(deg2, outfile2)
write_xlsx(deg3, outfile3)
write_xlsx(deg4, outfile4)
