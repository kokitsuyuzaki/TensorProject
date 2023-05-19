source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]
outfile3 <- args[4]
outfile4 <- args[5]

# Load
load(infile)

# Component1: D1,D5,D6 vs Other
deg1 <- DEG_Wilcox(logrpkm, A=c(23,27,28), B=setdiff(seq(39), c(23,27,28)))
# Component2: AB vs CDE
deg2 <- DEG_Wilcox(logrpkm, A=1:16, B=17:39)
# Component3: ACD vs BE
deg3 <- DEG_Wilcox(logrpkm, A=c(1:7, 17:30), B=c(8:16, 31:39))
# Component4: ADE vs BC
deg4 <- DEG_Wilcox(logrpkm, A=c(1:7, 23:39), B=c(8:22))

# Save
write_xlsx(deg1, outfile1)
write_xlsx(deg2, outfile2)
write_xlsx(deg3, outfile3)
write_xlsx(deg4, outfile4)
