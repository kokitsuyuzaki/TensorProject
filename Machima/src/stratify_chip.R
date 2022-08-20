source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
chromosome <- commandArgs(trailingOnly=TRUE)[4]
outfile1 <- commandArgs(trailingOnly=TRUE)[5]
outfile2 <- commandArgs(trailingOnly=TRUE)[6]
outfile3 <- commandArgs(trailingOnly=TRUE)[7]

# Loading
counts <- read.csv(infile1, header=FALSE)
region_names <- unlist(read.csv(infile2, header=FALSE))
ids <- read.csv(infile3, header=FALSE)

# Stratification
target <- grep(paste0(chromosome, "_"), region_names)
counts <- counts[target, ]
region_names <- region_names[target]

# Save
write.table(counts, file=outfile1,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(region_names, file=outfile2,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(ids, file=outfile3,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
