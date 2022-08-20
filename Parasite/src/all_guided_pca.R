# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# guided-PCA
resgPCA_At <- svd(scaled_At_logTPM %*% scaled_Y_At_all)
resgPCA_Pj <- svd(scaled_Pj_logTPM %*% scaled_Y_Pj_all)

resgPCA_At <- .flipSignSVD(resgPCA_At, c(1, -1))
resgPCA_Pj <- .flipSignSVD(resgPCA_Pj, c(1, -1))

score_At <- t(scaled_At_logTPM) %*% resgPCA_At$u
score_Pj <- t(scaled_Pj_logTPM) %*% resgPCA_Pj$u

save(resgPCA_At, resgPCA_Pj, score_At, score_Pj, file=outfile)
