# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# pLS
# resgPLS <- irlba(t(scaled_At_logTPM_RBH) %*% scaled_Pj_logTPM_RBH, 4)
resgPLS <- svd(t(scaled_At_logTPM_RBH) %*% scaled_Pj_logTPM_RBH)
# score_At <- resgPLS$u
# score_Pj <- resgPLS$v
score_At <- resgPLS$u[, seq(4)]
score_Pj <- resgPLS$v[, seq(4)]

# Output
save(resgPLS, score_At, score_Pj, file=outfile)
