source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile1 <- commandArgs(trailingOnly=TRUE)[2]
outfile2 <- commandArgs(trailingOnly=TRUE)[3]

# Loading
load(infile)

# Output
write.table(res_dimreduct$U, outfile1,
	row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(t(res_dimreduct$V), outfile2,
	row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
