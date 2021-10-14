# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# NMF
res_nmf_At <- NMF(At_logTPM, J=5, algorithm="Frobenius", verbose=TRUE)
res_nmf_Pj <- NMF(Pj_logTPM, J=5, algorithm="Frobenius", verbose=TRUE)

# Output
save(res_nmf_At, res_nmf_Pj, file=outfile)
