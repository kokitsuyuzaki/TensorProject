source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# PCA
res.pca <- prcomp(t(logrpkm), center=TRUE, scale=FALSE)
res.pca.deg <- prcomp(t(logrpkm.deg), center=TRUE, scale=FALSE)

# Save
save(res.pca, res.pca.deg, file=outfile)
