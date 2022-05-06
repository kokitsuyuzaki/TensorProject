source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
load(infile)

# Find Best Hit Rank
target = which(min(df$Log10_TestRecError) == df$Log10_TestRecError)[1]
bestfit_rank <- unlist(df[target, 1:3])

# Output
save(bestfit_rank, file=outfile)
