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
	# Generated NaN sometimes, if the rank is not optimal
	count <- 1
	tmp <- try(1 + "1")
	while((class(tmp) == "try-error") && (count <= 10)){
		tmp <- try(NTF(X=X, rank=bestfit_rank, algorithm="KL",
			init="Random", num.iter=20, L2_A=1e-5))
		count <- count + 1
	}
	if(class(tmp) == "try-error"){
		stop("Unstable Rank Parameter!!!")
	}
	outList[[i]] <- tmp
}
error <- unlist(lapply(outList, function(x){
	rev(x$RecError)[1]
}))
target <- which(error == min(error))[1]
out <- outList[[target]]

# Output
save(out, file=outfile)
