source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

infile <- args[1]
wordsize <- args[2]
type <- args[3]
outfile <- args[4]

# Input
load(infile)

# t-SNE
nc <- ncol(outPCA$u)
distPCA <- dist(outPCA$u[, seq(min(nc, 10))])
outtSNE <- Rtsne(distPCA, is_distance=TRUE)

# Output
save(outtSNE, file=outfile)
