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

# NMF (Init)
out <- BijNMF(X_RNA, X_Epi, J=3, init="NMF", num.iter=30)
X_GAM <- out$X_GAM_L

# T
T <- X_Epi %*% ginv(X_GAM)

# Output
write.table(T, outfile1, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(X_GAM, outfile2, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
