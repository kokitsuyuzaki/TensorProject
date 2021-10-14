source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

id <- args[1]
file <- paste0("data/", id, "/host.fna")
wordsize <- as.numeric(args[2])
outfile <- args[3]

# Input
sequence <- read.fasta(file=file, seqtype="DNA", strip.desc=TRUE)

# Frequency A,T,G,C
rhostats <- lapply(sequence, function(s, wordsize){
    rho(c(s, ' ', rev(comp(s))), wordsize=wordsize)
}, wordsize=wordsize)

out <- matrix(0, nrow=length(rhostats), ncol=length(rhostats[[1]]))
for(i in seq_along(rhostats)){
  out[i,] <- rhostats[[i]]
}
rownames(out) <- names(rhostats)
colnames(out) <- names(rhostats[[1]])

# Output
write.csv(out, outfile)
