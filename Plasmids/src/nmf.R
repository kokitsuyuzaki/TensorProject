source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

wordsize <- as.numeric(args[1])
J <- as.numeric(args[2])
outfile <- args[3]
hostfile <- paste0("data/", wordsize, "mer_host.csv")

X <- read.csv(hostfile, row.names=1)
X <- t(X)

# NMF
out <- NMF(X, J=J, algorithm="Frobenius", verbose=TRUE)

# Output
save(out, file=outfile)
