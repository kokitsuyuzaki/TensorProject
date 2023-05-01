source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]
outfile3 <- args[4]
outfile4 <- args[5]

# Load
load(infile)

# Wicoxon's rank-sum test (Component1, D1,D5,D6 vs Other)
allgene1 <- apply(logcount, 1, function(x){
	wilcox.test(x[ c(23,27:28)], x[setdiff(seq(39), c(23,27:28))])$p.value
})
allgene1 <- data.frame(genename=rownames(logcount), pval=allgene1)
rownames(allgene1) <- NULL
deggene1 <- allgene1[which(rank(allgene1$pval) <= 100), ]
deg1 <- list(allgene=allgene1, deg=deggene1)

# Wicoxon's rank-sum test (Component2, A, B vs C, D, E)
allgene2 <- apply(logcount, 1, function(x){
	wilcox.test(x[ 1:16], x[17:39])$p.value
})
allgene2 <- data.frame(genename=rownames(logcount), pval=allgene2)
rownames(allgene2) <- NULL
deggene2 <- allgene2[which(rank(allgene2$pval) <= 100), ]
deg2 <- list(allgene=allgene2, deg=deggene2)

# Wicoxon's rank-sum test (Component3, A, C, D vs B, E)
allgene3 <- apply(logcount, 1, function(x){
	wilcox.test(x[c(1:7, 17:30)], x[c(8:16, 31:39)])$p.value
})
allgene3 <- data.frame(genename=rownames(logcount), pval=allgene3)
rownames(allgene3) <- NULL
deggene3 <- allgene3[which(rank(allgene3$pval) <= 100), ]
deg3 <- list(allgene=allgene3, deg=deggene3)

# Wicoxon's rank-sum test (Component4, A, D, E vs B, C)
allgene4 <- apply(logcount, 1, function(x){
	wilcox.test(x[c(1:7, 23:39)], x[8:22])$p.value
})
allgene4 <- data.frame(genename=rownames(logcount), pval=allgene4)
rownames(allgene4) <- NULL
deggene4 <- allgene4[which(rank(allgene4$pval) <= 100), ]
deg4 <- list(allgene=allgene4, deg=deggene4)

# Save
write_xlsx(deg1, outfile1)
write_xlsx(deg2, outfile2)
write_xlsx(deg3, outfile3)
write_xlsx(deg4, outfile4)
