source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# sPLSDA
res.splsda <- sPLSDA(X=t(logcount), Y=dummyY, k=5, lambda=9)
res.splsda.deg <- sPLSDA(X=t(logcount.deg), Y=dummyY, k=5, lambda=9)

# Save
save(res.splsda, res.splsda.deg, file=outfile)
