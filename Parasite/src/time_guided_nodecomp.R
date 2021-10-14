# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# guided-PCA
resNoDecomp_At <- scaled_At_logTPM %*% t(ginv(Y_At_time))
resNoDecomp_Pj <- scaled_Pj_logTPM %*% t(ginv(Y_Pj_time))

score_At <- t(scaled_At_logTPM) %*% resNoDecomp_At[,seq(2)]
score_Pj <- t(scaled_Pj_logTPM) %*% resNoDecomp_Pj[,seq(2)]

save(resNoDecomp_At, resNoDecomp_Pj, score_At, score_Pj, file=outfile)
