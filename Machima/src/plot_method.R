source("src/Functions.R")

infile1 = commandArgs(trailingOnly=TRUE)[1]
infile2 = commandArgs(trailingOnly=TRUE)[2]
outfile1 = commandArgs(trailingOnly=TRUE)[3]
outfile2 = commandArgs(trailingOnly=TRUE)[4]

W <- as.matrix(read.csv(infile1))
X_GAM <- as.matrix(read.csv(infile2))

png(file=outfile1, width=500, height=500)
par(ps=30)
image.plot(W, main="Estimated W")
dev.off()

png(file=outfile2, width=500, height=500)
par(ps=30)
image.plot(X_GAM, main="Estimated X_GAM")
dev.off()
