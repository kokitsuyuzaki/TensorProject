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
sigma_dist <- sigma_distance(kmer_host, kmer_plasmid, wordsize)

# Output
write.csv(sigma_dist, outfile)
