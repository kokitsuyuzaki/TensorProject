source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# PLSSVD
res.plssvd <- PLSSVD(X=t(logcount), Y=dummyY, k=5)
res.plssvd.deg <- PLSSVD(X=t(logcount.deg), Y=dummyY, k=5)

# Save
save(res.plssvd, res.plssvd.deg, file=outfile)
