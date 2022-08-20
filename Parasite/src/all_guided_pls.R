# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# guided-PLS
resgPLS <- guidedPLS(t(scaled_At_logTPM), t(scaled_Pj_logTPM),
    scaled_Y_At_all, scaled_Y_Pj_all, 4, cortest=TRUE)
score_At <- resgPLS$score1
score_Pj <- resgPLS$score2

# Output
save(resgPLS, score_At, score_Pj, file=outfile)
