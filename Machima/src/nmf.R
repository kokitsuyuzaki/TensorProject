source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
mat <- as.matrix(read.csv(infile1, header=FALSE))
label <- unlist(read.delim(infile2, header=FALSE))

# NMF
J <- min(length(unique(label)), 10)
res_dimreduct <- NMF(mat, J=J)

# Save
save(res_dimreduct, file=outfile)
