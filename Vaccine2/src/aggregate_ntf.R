source("src/Functions.R")

# Parameter
CP_MAX_RANK <- as.numeric(commandArgs(trailingOnly=TRUE)[1])
CP_RANKS = seq(CP_MAX_RANK)
K <- as.numeric(commandArgs(trailingOnly=TRUE)[2])
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Aggregate
df <- aggregate_ntf(CP_RANKS, K)

# Output
save(df, file=outfile)
