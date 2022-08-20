# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# PCA (At)
res_pca_At <- svd(scaled_At_logTPM)

# PCA (Pj)
res_pca_Pj <- svd(scaled_Pj_logTPM)

# Output
save(res_pca_At, res_pca_Pj, file=outfile)
