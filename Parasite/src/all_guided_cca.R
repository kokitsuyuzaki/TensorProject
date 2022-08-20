# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# guided-CCA
resgCCA <- guidedCCA(t(scaled_At_logTPM), t(scaled_Pj_logTPM),
    scaled_Y_At_all, scaled_Y_Pj_all, c(-1, 1), c(1, 1))

score_At <- resgCCA$score1
score_Pj <- resgCCA$score2

# Output
save(resgCCA, score_At, score_Pj, file=outfile)
