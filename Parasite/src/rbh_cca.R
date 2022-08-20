# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# CCA
resgCCA <- rcc(At_logTPM_RBH, Pj_logTPM_RBH, 1E-3, 1E-3)
score_At <- resgCCA$xcoef
score_Pj <- resgCCA$ycoef

# Output
save(resgCCA, score_At, score_Pj, file=outfile)
