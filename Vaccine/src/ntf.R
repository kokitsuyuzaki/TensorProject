source("src/Functions.R")
# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]
r <- as.numeric(commandArgs(trailingOnly=TRUE)[3])
k <- as.numeric(commandArgs(trailingOnly=TRUE)[4])

# Loading
load(infile)

# Mask Tensor
Ms <- kFoldMaskTensor(X, k=10, avoid.zero=TRUE, seeds=123)
M <- Ms[[k]]

# NTF
# Generated NaN sometimes, if the rank is not optimal
tmp <- try(NTF(X=X, M=M, rank=r, algorithm="KL", num.iter=30))
if(class(tmp) == "try-error"){
	out <- NTF(X=X, M=M, rank=r, algorithm="KL", num.iter=30)
}else{
	out <- tmp
}

# Output
save(out, file=outfile)
