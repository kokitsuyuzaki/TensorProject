source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# PCA
res.pca <- prcomp(t(logcount), center=TRUE, scale=FALSE)
res.pca.deg <- prcomp(t(logcount.deg), center=TRUE, scale=FALSE)

# Save
save(res.pca, res.pca.deg, file=outfile)
