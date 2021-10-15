source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

wordsize <- as.numeric(args[1])
outfile <- args[2]

file1 <- paste0("data/", wordsize, "mer_host.csv")
file2 <- paste0("data/", wordsize, "mer_plasmid.csv")

kmer_host <- read.csv(file1, header=TRUE, row.names=1)
kmer_plasmid <- read.csv(file2, header=TRUE, row.names=1)

kmer_host <- as.matrix(kmer_host)
kmer_plasmid <- as.matrix(kmer_plasmid)

# Distance
inner_product <- kmer_host %*% t(kmer_plasmid)
inner_product_dist <- 1 / inner_product

# Output
write.csv(inner_product_dist, outfile)
