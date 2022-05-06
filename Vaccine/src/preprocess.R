source("src/Functions.R")

outfile <- commandArgs(trailingOnly=TRUE)[1]

# For Debug
# X <- toyModel("CP")

X <- array(0, dim=c(12,14,1516))
index <- 0:13
for(i in index){
	tmpX <- read.csv(paste0("data/", i, "_data.csv"), row.names=1)
	X[,i+1,] <- t(tmpX)
}
dimnames(X) <- list(
	S=colnames(tmpX),
	T=c(paste0(1, "_", seq(7)), paste0(2, "_", seq(7))),
	N=seq(1516))
X <- as.tensor(X)

save(X, file=outfile)