source("src/Functions.R")
# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]
trials <- as.numeric(commandArgs(trailingOnly=TRUE)[3])
r <- as.numeric(commandArgs(trailingOnly=TRUE)[4])
k <- as.numeric(commandArgs(trailingOnly=TRUE)[5])
K <- as.numeric(commandArgs(trailingOnly=TRUE)[6])

# Loading
load(infile)

# Mask Tensor
kFoldMaskTensor(vaccine_tensor, k=K, avoid.zero=TRUE, seeds=123) %>% .[[k]] -> M

# NTF
map(seq(trials), function(x){
    NTF(X=vaccine_tensor, M=M, rank=r, algorithm="KL", init="ABS-SVD", num.iter=100, L2_A=1e+5, verbose=TRUE)
}) -> outList

# Select result with the minimum error
map(outList, function(x){rev(x$RecError)[1]}) %>% unlist %>% `==`(min(.)) %>% which %>% .[1] %>% outList[[.]] -> out

# Output
save(out, file=outfile)