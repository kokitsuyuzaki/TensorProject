# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# multi-guided-PCA

# At
D_At <- matrix(0, nrow=nrow(scaled_At_logTPM)+3+2+2, ncol=nrow(scaled_At_logTPM)+3+2+2)
D_At[1:10000, 1:10000] <- scaled_At_logTPM %*% t(scaled_At_logTPM)
D_At[10001:10003, 10001:10003] <- t(Y_At_time) %*% Y_At_time
D_At[10004:10005, 10004:10005] <- t(Y_At_wol) %*% Y_At_wol
D_At[10006:10007, 10006:10007] <- t(Y_At_parasm) %*% Y_At_parasm

C_At <- D_At
C_At[1:10000, 10001:10003] <- scaled_At_logTPM %*% Y_At_time
C_At[1:10000, 10004:10005] <- scaled_At_logTPM %*% Y_At_wol
C_At[1:10000, 10006:10007] <- scaled_At_logTPM %*% Y_At_parasm

C_At[10001:10003, 1:10000] <- t(Y_At_time) %*% t(scaled_At_logTPM)
C_At[10001:10003, 10001:10003] <- t(Y_At_time) %*% Y_At_time
C_At[10001:10003, 10004:10005] <- t(Y_At_time) %*% Y_At_wol
C_At[10001:10003, 10006:10007] <- t(Y_At_time) %*% Y_At_parasm

C_At[10004:10005, 1:10000] <- t(Y_At_wol) %*% t(scaled_At_logTPM)
C_At[10004:10005, 10001:10003] <- t(Y_At_wol) %*% Y_At_time
C_At[10004:10005, 10004:10005] <- t(Y_At_wol) %*% Y_At_wol
C_At[10004:10005, 10006:10007] <- t(Y_At_wol) %*% Y_At_parasm

C_At[10006:10007, 1:10000] <- t(Y_At_parasm) %*% t(scaled_At_logTPM)
C_At[10006:10007, 10001:10003] <- t(Y_At_parasm) %*% Y_At_time
C_At[10006:10007, 10004:10005] <- t(Y_At_parasm) %*% Y_At_wol
C_At[10006:10007, 10006:10007] <- t(Y_At_parasm) %*% Y_At_parasm

print("geigen (At)")
resmgPCA_At <- geigen::geigen(C_At, D_At, symmetric=FALSE, only.values=FALSE)
score_At <- t(scaled_At_logTPM) %*% t(ginv(Re(resmgPCA_At$vectors[1:10000, seq(2)])))

# Pj
D_Pj <- matrix(0, nrow=nrow(scaled_Pj_logTPM)+3+2+2, ncol=nrow(scaled_Pj_logTPM)+3+2+2)
D_Pj[1:10000, 1:10000] <- scaled_Pj_logTPM %*% t(scaled_Pj_logTPM)
D_Pj[10001:10003, 10001:10003] <- t(Y_Pj_time) %*% Y_Pj_time
D_Pj[10004:10005, 10004:10005] <- t(Y_Pj_wol) %*% Y_Pj_wol
D_Pj[10006:10007, 10006:10007] <- t(Y_Pj_parasm) %*% Y_Pj_parasm

C_Pj <- D_Pj
C_Pj[1:10000, 10001:10003] <- scaled_Pj_logTPM %*% Y_Pj_time
C_Pj[1:10000, 10004:10005] <- scaled_Pj_logTPM %*% Y_Pj_wol
C_Pj[1:10000, 10006:10007] <- scaled_Pj_logTPM %*% Y_Pj_parasm

C_Pj[10001:10003, 1:10000] <- t(Y_Pj_time) %*% t(scaled_Pj_logTPM)
C_Pj[10001:10003, 10001:10003] <- t(Y_Pj_time) %*% Y_Pj_time
C_Pj[10001:10003, 10004:10005] <- t(Y_Pj_time) %*% Y_Pj_wol
C_Pj[10001:10003, 10006:10007] <- t(Y_Pj_time) %*% Y_Pj_parasm

C_Pj[10004:10005, 1:10000] <- t(Y_Pj_wol) %*% t(scaled_Pj_logTPM)
C_Pj[10004:10005, 10001:10003] <- t(Y_Pj_wol) %*% Y_Pj_time
C_Pj[10004:10005, 10004:10005] <- t(Y_Pj_wol) %*% Y_Pj_wol
C_Pj[10004:10005, 10006:10007] <- t(Y_Pj_wol) %*% Y_Pj_parasm

C_Pj[10006:10007, 1:10000] <- t(Y_Pj_parasm) %*% t(scaled_Pj_logTPM)
C_Pj[10006:10007, 10001:10003] <- t(Y_Pj_parasm) %*% Y_Pj_time
C_Pj[10006:10007, 10004:10005] <- t(Y_Pj_parasm) %*% Y_Pj_wol
C_Pj[10006:10007, 10006:10007] <- t(Y_Pj_parasm) %*% Y_Pj_parasm

print("geigen (Pj)")
resmgPCA_Pj <- geigen::geigen(C_Pj, D_Pj, symmetric=FALSE, only.values=FALSE)
score_Pj <- t(scaled_Pj_logTPM) %*% t(ginv(Re(resmgPCA_Pj$vectors[1:10000, seq(2)])))

# Output
save(resmgPCA_At, resmgPCA_Pj, score_At, score_Pj, file=outfile)
