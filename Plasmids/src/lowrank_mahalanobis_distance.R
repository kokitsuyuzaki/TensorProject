source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

infile <- args[1]
hostid <- args[2]
wordsize <- as.numeric(args[3])
outfile <- args[4]

# Loading
Y <- as.matrix(read.csv(infile, header=TRUE))
if(ncol(Y) == 1){
	Y <- as.vector(Y)
}
filename <- paste0("data/", wordsize, "mer_plasmid.csv")
kmer_plasmid <- as.matrix(read.csv(filename, header=TRUE, row.names=1))

# Distance
lowrank_mahalanobis_dist <- lowrank_mahalanobis_distance(Y, kmer_plasmid, wordsize)
rownames(lowrank_mahalanobis_dist) <- hostid

# Output
write.csv(lowrank_mahalanobis_dist, outfile)
