source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# PLSSVD
res.plssvd <- PLSSVD(X=t(logrpkm), Y=dummyY, k=5, cortest=TRUE)
res.plssvd.deg <- PLSSVD(X=t(logrpkm.deg), Y=dummyY, k=5, cortest=TRUE)

# Save
save(res.plssvd, res.plssvd.deg, file=outfile)
