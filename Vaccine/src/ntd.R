source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]
r1 <- as.numeric(commandArgs(trailingOnly=TRUE)[3])
r2 <- as.numeric(commandArgs(trailingOnly=TRUE)[4])
r3 <- as.numeric(commandArgs(trailingOnly=TRUE)[5])
k <- as.numeric(commandArgs(trailingOnly=TRUE)[6])
K <- as.numeric(commandArgs(trailingOnly=TRUE)[7])

# Loading
load(infile)

# Mask Tensor
Ms <- kFoldMaskTensor(X, k=K, avoid.zero=TRUE, seeds=123)
M <- Ms[[k]]

# NTD
out <- NTD(X=X, M=M, rank=c(r1,r2,r3), algorithm="KL", num.iter=20)

# Output
save(out, file=outfile)
