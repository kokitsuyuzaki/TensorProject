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
map(seq(trials), function(x){
    NTF(X=vaccine_tensor, rank=bestfit_rank, algorithm="KL", init="ABS-SVD", num.iter=100, L2_A=1e+5, verbose=TRUE)
}) -> outList

# Select result with the minimum error
map(outList, function(x){rev(x$RecError)[1]}) %>% unlist %>% `==`(min(.)) %>% which %>% .[1] %>% outList[[.]] -> out

# Output
save(out, file=outfile)