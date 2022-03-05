source("src/Functions.R")

infile1 = commandArgs(trailingOnly=TRUE)[1]
infile2 = commandArgs(trailingOnly=TRUE)[2]
outfile1 = commandArgs(trailingOnly=TRUE)[3]
outfile2 = commandArgs(trailingOnly=TRUE)[4]
# infile1='data/toydata1/X_RNA.csv'
# infile2='data/toydata1/X_Epi.csv'

# Setting
X_RNA <- as.matrix(read.csv(infile1, header=FALSE))
X_Epi <- as.matrix(read.csv(infile2, header=FALSE))
X <- matrix(0,
	nrow=nrow(X_RNA)+nrow(X_Epi),
	ncol=ncol(X_RNA)+ncol(X_Epi))
X[1:nrow(X_RNA), 1:ncol(X_RNA)] <- X_RNA
X[(nrow(X_RNA)+1):nrow(X), (ncol(X_RNA)+1):ncol(X)] <- X_Epi
maskX <- matrix(1,
	nrow=nrow(X_RNA)+nrow(X_Epi),
	ncol=ncol(X_RNA)+ncol(X_Epi))
maskX[(nrow(X_RNA)+1):nrow(X), 1:ncol(X_RNA)] <- 0
maskX[1:nrow(X_RNA), (ncol(X_RNA)+1):ncol(X)] <- 0

# NMF
out <- NMF(X, maskX, J=3)
X_GAM <- (out$U %*% t(out$V))[1:nrow(X_RNA), (ncol(X_RNA)+1):ncol(X)]

# W
W <- X_GAM %*% ginv(X_Epi)

# Output
write.table(W, outfile1, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(X_GAM, outfile2, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
