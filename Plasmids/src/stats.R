source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)
id = args[1]
outfile = args[2]

file1 <- paste0("data/", id, "/host.fna")
file2 <- paste0("data/", id, "/plasmid.fna")

seq1 <- read.fasta(file=file1, seqtype="DNA", strip.desc=TRUE)
seq2 <- read.fasta(file=file2, seqtype="DNA", strip.desc=TRUE)

# Stats
myName <- c(getName(seq1), getName(seq2))
Length <- c(unlist(lapply(seq1, length)), unlist(lapply(seq2, length)))
GCcontent <- c(unlist(lapply(seq1, GC)), unlist(lapply(seq2, GC)))
GCcontent <- round(GCcontent, digits=3) # Global G+C content
Host_or_Plasmid <- c(rep("Host", length=length(seq1)),
    rep("Plasmid", length=length(seq2)))

# data frame
df <- data.frame(Host_or_Plasmid, myName, Length, GCcontent)
write.csv(df, file = outfile, quote=TRUE, row.names=FALSE)
