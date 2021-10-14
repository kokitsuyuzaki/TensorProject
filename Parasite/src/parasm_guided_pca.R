# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# guided-PCA
resgPCA_At <- svd(scaled_At_logTPM %*% Y_At_parasm)
resgPCA_Pj <- svd(scaled_Pj_logTPM %*% Y_Pj_parasm)

resgPCA_At <- .flipSignSVD(resgPCA_At, c(1, 1))
resgPCA_Pj <- .flipSignSVD(resgPCA_Pj, c(1, -1))

score_At <- t(scaled_At_logTPM) %*% resgPCA_At$u[, seq(2)]
score_Pj <- t(scaled_Pj_logTPM) %*% resgPCA_Pj$u[, seq(2)]

save(resgPCA_At, resgPCA_Pj, score_At, score_Pj, file=outfile)
