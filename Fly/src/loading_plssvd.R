source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile1 <- args[3]
outfile2 <- args[4]
outfile3 <- args[5]
outfile4 <- args[6]

# Load
load(infile1)
load(infile2)

# DEG
deg1 <- DEG_PLSSVD(rpkm, res.plssvd, 1)
deg2 <- DEG_PLSSVD(rpkm, res.plssvd, 2)
deg3 <- DEG_PLSSVD(rpkm, res.plssvd, 3)
deg4 <- DEG_PLSSVD(rpkm, res.plssvd, 4)

# Save
write_xlsx(deg1, outfile1)
write_xlsx(deg2, outfile2)
write_xlsx(deg3, outfile3)
write_xlsx(deg4, outfile4)
