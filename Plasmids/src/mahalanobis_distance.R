source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

hostid <- args[1]
wordsize <- as.numeric(args[2])
outfile <- args[3]

fileid <- read.csv("data/truepairs.txt", header=FALSE, sep="|")
fileid <- fileid[which(fileid[,4] == hostid), ][1,1]

file1 <- paste0("data/", fileid, "/host.fna")
file2 <- paste0("data/", wordsize, "mer_plasmid.csv")

seqs_host <- read.fasta(file=file1, seqtype="DNA", strip.desc=TRUE)
kmer_plasmid <- read.csv(file2, header=TRUE, row.names=1)
kmer_plasmid <- as.matrix(kmer_plasmid)

# Distance
mahalanobis_dist <- mahalanobis_distance(seqs_host, kmer_plasmid, wordsize)

# Output
rownames(mahalanobis_dist) <- hostid
write.csv(mahalanobis_dist, outfile)
