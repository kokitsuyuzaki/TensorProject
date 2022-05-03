source("src/Functions.R")

infile1 = commandArgs(trailingOnly=TRUE)[1]
infile2 = commandArgs(trailingOnly=TRUE)[2]
outfile1 = commandArgs(trailingOnly=TRUE)[3]
outfile2 = commandArgs(trailingOnly=TRUE)[4]
# infile1='data/toydata1/X_RNA.csv'
# infile2='data/toydata1/X_Epi.csv'

# Setting
X_RNA <- as.matrix(read.csv(infile1, header=FALSE))
X_Epi <- as.matrix(read.csv(infile2, header=FALSE))

# Bi-CCA
X.clst <- c(rep(1,90), rep(2,90), rep(3,90), rep(4,30))
Y.clst <- c(rep(1,5), rep(2,5), rep(3,5), rep(4,5))
RandZ0 <- matrix(runif(nrow(X_RNA)*ncol(X_Epi)),
      nrow=nrow(X_RNA), ncol=ncol(X_Epi))

# BiCCA
td <- tempdir()
out <- try(BiCCA(X=X_RNA, Z0=RandZ0, Y=X_Epi,
      K = 3,
      alpha = 0.1,
      lambda = 0.5,
      X.clst = X.clst,
      Y.clst = Y.clst,
      num.iteration = 30,
      temp.path = td,
      tolerance = 1e-10,
      save = TRUE,
      block.size =10000))
X_GAM <- out$Z_est

# T
T <- X_Epi %*% ginv(X_GAM)

# Output
write.table(T, outfile1, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(X_GAM, outfile2, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
