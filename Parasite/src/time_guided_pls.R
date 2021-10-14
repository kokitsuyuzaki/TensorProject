# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# guided-PLS
resgPLS <- guidedPLS(t(scaled_At_logTPM), t(scaled_Pj_logTPM),
    Y_At_time, Y_Pj_time, c(1,-1))
score_At <- resgPLS$score1
score_Pj <- resgPLS$score2

# Output
save(resgPLS, score_At, score_Pj, file=outfile)
