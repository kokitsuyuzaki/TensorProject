args <- commandArgs(trailingOnly = TRUE)

wordsize <- args[1]
type <- args[2]
outfile <- args[3]

# Input
file <- paste0("data/", wordsize, "mer_", type, ".csv")
kmer <- read.csv(file, header=TRUE, row.names=1)

# PCA
scaled_kmer <- scale(kmer, center=TRUE, scale=FALSE)
outPCA <- svd(scaled_kmer)

# Output
save(outPCA, file=outfile)
