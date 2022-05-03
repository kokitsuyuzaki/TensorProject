source("src/Functions.R")

infile1 = commandArgs(trailingOnly=TRUE)[1]
infile2 = commandArgs(trailingOnly=TRUE)[2]
outfile1 = commandArgs(trailingOnly=TRUE)[3]
outfile2 = commandArgs(trailingOnly=TRUE)[4]
# infile1='data/toydata3/X_RNA.csv'
# infile2='data/toydata3/X_Epi.csv'

# Setting
X_RNA <- as.matrix(read.csv(infile1, header=FALSE))
X_Epi <- as.matrix(read.csv(infile2, header=FALSE))
T <- as.matrix(read.csv("data/T.csv", header=FALSE))

# NMF
out <- JointBetaNMTF(X_RNA, X_Epi, T=T,
	fixW_RNA=FALSE, fixH_RNA=FALSE, fixT=TRUE,
	J=3, Beta=1, init="Random", num.iter=30, viz=TRUE,
	L1_W_RNA=1, L2_W_RNA=1,
	L1_H_RNA=1, L2_H_RNA=1,
	L1_T=1, L2_T=1,
	L1_H_Epi=1, L2_H_Epi=1)

# Output
write.table(out$T, outfile1, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(out$X_GAM, outfile2, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
