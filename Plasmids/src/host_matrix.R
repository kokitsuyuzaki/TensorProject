source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

hostid <- args[1]
wordsize <- as.numeric(args[2])
outfile <- args[3]

# Loading
fileid <- read.csv("data/truepairs.txt", header=FALSE, sep="|")
fileid <- fileid[which(fileid[,4] == hostid), ][1,1]
filename <- paste0("data/", fileid, "/host.fna")
seqs_host <- read.fasta(file=filename, seqtype="DNA", strip.desc=TRUE)

# Rollapply
Y <- host_matrix(seqs_host, wordsize)

# Output
write.csv(Y, outfile, row.names=FALSE, quote=FALSE)
