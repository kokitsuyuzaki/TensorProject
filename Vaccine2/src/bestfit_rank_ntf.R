source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
load(infile)

# Find Best Hit Rank
ranks <- unique(df$Rank)
testerror <- sapply(ranks, function(x){
	target <- which(df$Rank == x)
	median(df[target, "Log10_TestRecError"])
})
bestfit_rank = which(min(testerror) == testerror)

# Output
save(bestfit_rank, file=outfile)
