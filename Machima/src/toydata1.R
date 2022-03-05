source("src/Functions.R")

######## 100 genes × 300 cells ########
# Block1 (lamda100): [1:30, 1:90]
# Block2 (lamda100): [31:60, 91:180]
# Block3 (lamda100): [61:90, 181:270]
X_RNA = nnTensor::toyModel(model="siNMF_Easy")[[1]]

######## 100 genes × 200 cells ########
# Block1 (lamda100): [1:30, 61:120]
# Block2 (lamda100): [31:60, 121:180]
# Block3 (lamda100): [61:90, 1:60]
X_GAM = nnTensor::toyModel(model="siNMF_Easy")[[2]]

######## 400 bins × 100 genes ########
Winv = matrix(0, nrow=400, ncol=100)
# Block1
Winv[1:100, 1:30] <- 1
# Block2
Winv[201:300, 31:60] <- 1
# Block3
Winv[101:200, 61:90] <- 1

######## 100 genes × 400 bins ########
W <- ginv(Winv)

######## 400 bins × 200 cells ########
X_Epi <- Winv %*% X_GAM

# Output
write.table(X_RNA, "data/toydata1/X_RNA.csv",
	row.names=FALSE, col.names=FALSE,
	quote=FALSE, sep=",")
write.table(X_GAM, "data/toydata1/X_GAM.csv",
	row.names=FALSE, col.names=FALSE,
	quote=FALSE, sep=",")
write.table(X_Epi, "data/toydata1/X_Epi.csv",
	row.names=FALSE, col.names=FALSE,
	quote=FALSE, sep=",")
write.table(W, "data/toydata1/W.csv",
	row.names=FALSE, col.names=FALSE,
	quote=FALSE, sep=",")
write.table(Winv, "data/toydata1/Winv.csv",
	row.names=FALSE, col.names=FALSE,
	quote=FALSE, sep=",")