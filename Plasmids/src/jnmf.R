source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

wordsize <- as.numeric(args[1])
J <- as.numeric(args[2])
outfile <- args[3]
hostfile <- paste0("data/", wordsize, "mer_host.csv")
plasmidfile <- paste0("data/", wordsize, "mer_plasmid.csv")

host <- read.csv(hostfile, row.names=1)
plasmid <- read.csv(plasmidfile, row.names=1)

# jNMF
X <- list(t(host), t(plasmid))
out <- jNMF(X, J=J, algorithm="Frobenius", verbose=TRUE)

# Output
save(out, file=outfile)
