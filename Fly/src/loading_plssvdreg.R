source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Load
load(infile1)
load(infile2)

# DEG
deg <- DEG_PLSSVD(rpkm, res.plssvdreg, 1)

# Save
write_xlsx(deg, outfile)
