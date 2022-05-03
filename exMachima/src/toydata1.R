source("src/Functions.R")
T <- as.matrix(read.csv("data/T.csv", header=FALSE))

######## 100 genes × 300 cells ########
# Block1 (lamda100): [1:30, 1:90]
# Block2 (lamda100): [31:60, 91:180]
# Block3 (lamda100): [61:90, 181:270]
X_RNA = nnTensor::toyModel(model="siNMF_Easy")[[1]]

######## 100 genes × 20 samples ########
# Block1 (lamda100): [1:30, 61:120]
# Block2 (lamda100): [31:60, 121:180]
# Block3 (lamda100): [61:90, 1:60]
X_GAM = nnTensor::toyModel(model="siNMF_Easy")[[2]]
X_GAM = X_GAM[, c(1:5, 61:65, 121:125, 181:185)]

######## 400 bins × 20 samples ########
X_Epi <- T %*% X_GAM

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