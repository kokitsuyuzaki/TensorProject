source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# t-SNE
res.tsne <- Rtsne(dist(res.pca$x[,1:20]), is.distance=TRUE, perplexity=10)
res.tsne.deg <- Rtsne(dist(res.pca.deg$x[,1:20]), is.distance=TRUE, perplexity=10)

# Save
save(res.tsne, res.tsne.deg, file=outfile)
