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
W <- as.matrix(read.csv(infile4, header=FALSE))
Winv <- as.matrix(read.csv(infile5, header=FALSE))

png(file=outfile, width=1500, height=1000)
par(ps=30)
layout(rbind(1:3, 4:6))
image.plot(X_RNA, main="X_RNA")
image.plot(X_GAM, main="X_GAM")
image.plot(X_Epi, main="X_Epi")
image.plot(W, main="W")
image.plot(Winv, main="inv(W)")
dev.off()