source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
df <- read.csv(infile)

# Find Best Hit Rank
testerror <- apply(df, 2, median)
bestfit_rank <- which(min(testerror) == testerror)

# Output
write.table(bestfit_rank, file=outfile, row.names=FALSE, col.names=FALSE)
