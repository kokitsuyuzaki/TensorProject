source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# PLSSVD-REG
res.plssvdreg <- PLSSVD(X=t(logrpkm), Y=as.matrix(PI), k=1, cortest=TRUE)
res.plssvdreg.deg <- PLSSVD(X=t(logrpkm.deg), Y=as.matrix(PI), k=1, cortest=TRUE)

# Save
save(res.plssvdreg, res.plssvdreg.deg, file=outfile)
