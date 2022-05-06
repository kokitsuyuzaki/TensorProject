source("src/Functions.R")

# Parameter
TUCKER_MAX_RANK_1 <- as.numeric(commandArgs(trailingOnly=TRUE)[1])
TUCKER_MAX_RANK_2 <- as.numeric(commandArgs(trailingOnly=TRUE)[2])
TUCKER_MAX_RANK_3 <- as.numeric(commandArgs(trailingOnly=TRUE)[3])
TUCKER_RANKS_1 = seq(TUCKER_MAX_RANK_1)
TUCKER_RANKS_2 = seq(TUCKER_MAX_RANK_2)
TUCKER_RANKS_3 = seq(TUCKER_MAX_RANK_3)
K <- as.numeric(commandArgs(trailingOnly=TRUE)[4])
outfile <- commandArgs(trailingOnly=TRUE)[5]

# Aggregate
df <- aggregate_ntd(TUCKER_RANKS_1, TUCKER_RANKS_2, TUCKER_RANKS_3, K)

# Output
save(df, file=outfile)