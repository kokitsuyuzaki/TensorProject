source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]
trials <- as.numeric(commandArgs(trailingOnly=TRUE)[4])

# Loading
load(infile1)
load(infile2)

# NTF
outList <- list()
for(i in seq(trials)){
	print(i)
	outList[[i]] <- NTD(X=X, rank=bestfit_rank, algorithm="KL",
		init="Random", num.iter=20)
}
error <- unlist(lapply(outList, function(x){
	rev(x$RecError)[1]
}))
target <- which(error == min(error))[1]
out <- outList[[target]]

# Output
save(out, file=outfile)