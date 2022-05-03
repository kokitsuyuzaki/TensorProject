source("src/Functions.R")

######## 400 bins × 100 genes ########
set.seed(1234)
T = matrix(1E-10*runif(400*100), nrow=400, ncol=100)
# Block1
T[1:100, 1:30] <- 10*runif(100*30)
# Block2
T[201:300, 31:60] <- 10*runif(100*30)
# Block3
T[101:200, 61:90] <- 10*runif(100*30)

######## 100 genes × 400 bins ########
Tinv <- ginv(T)
image.plot2(Tinv)

write.table(T, "data/T.csv",
    row.names=FALSE, col.names=FALSE,
    quote=FALSE, sep=",")
write.table(Tinv, "data/Tinv.csv",
    row.names=FALSE, col.names=FALSE,
    quote=FALSE, sep=",")