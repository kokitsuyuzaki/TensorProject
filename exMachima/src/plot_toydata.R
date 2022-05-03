source("src/Functions.R")

infile1 = commandArgs(trailingOnly=TRUE)[1]
infile2 = commandArgs(trailingOnly=TRUE)[2]
infile3 = commandArgs(trailingOnly=TRUE)[3]
infile4 = commandArgs(trailingOnly=TRUE)[4]
infile5 = commandArgs(trailingOnly=TRUE)[5]
outfile = commandArgs(trailingOnly=TRUE)[6]

X_RNA <- as.matrix(read.csv(infile1, header=FALSE))
X_GAM <- as.matrix(read.csv(infile2, header=FALSE))
X_Epi <- as.matrix(read.csv(infile3, header=FALSE))
T <- as.matrix(read.csv(infile4, header=FALSE))
Tinv <- as.matrix(read.csv(infile5, header=FALSE))

png(file=outfile, width=1500, height=1000)
par(ps=30)
layout(rbind(1:3, 4:6))
image.plot2(X_RNA, main="X_RNA")
image.plot2(X_GAM, main="X_GAM")
image.plot2(X_Epi, main="X_Epi")
image.plot2(T, main="T")
image.plot2(Tinv, main="inv(T)")
dev.off()