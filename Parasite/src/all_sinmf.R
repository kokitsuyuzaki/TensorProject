# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# Data
Xs <- list(At_logTPM=At_logTPM, Y_At_time=Y_At_time,
	Y_At_wol=Y_At_wol, Y_At_parasm=Y_At_parasm, 
	Pj_logTPM=Pj_logTPM, Y_Pj_time=Y_Pj_time,
	Y_Pj_wol=Y_Pj_wol, Y_Pj_parasm=Y_Pj_parasm)

# siNMF-type decomposition
params <- new("CoupledMWCAParams",
	# Data-wise setting
	Xs=Xs,
	mask=list(At_logTPM=NULL, Y_At_time=NULL,
	Y_At_wol=NULL, Y_At_parasm=NULL, 
	Pj_logTPM=NULL, Y_Pj_time=NULL,
	Y_Pj_wol=NULL, Y_Pj_parasm=NULL),
	weights=list(At_logTPM=1, Y_At_time=1,
	Y_At_wol=1, Y_At_parasm=1, 
	Pj_logTPM=1, Y_Pj_time=1,
	Y_Pj_wol=1, Y_Pj_parasm=1),
	# Common Factor Matrices
	common_model=list(
		At_logTPM=list(I1="A1", I2="A2"),
		Y_At_time=list(I2="A2", I3="A3"),
		Y_At_wol=list(I2="A2", I4="A4"),
		Y_At_parasm=list(I2="A2", I5="A5"),
		Pj_logTPM=list(I6="A6", I7="A7"),
		Y_Pj_time=list(I7="A7", I3="A3"),
		Y_Pj_wol=list(I7="A7", I4="A4"),
		Y_Pj_parasm=list(I7="A7", I5="A5")),
	common_initial=list(A1=NULL, A2=NULL, A3=NULL, A4=NULL,
		A5=NULL, A6=NULL, A7=NULL),
	common_algorithms=list(A1="myNMF", A2="myNMF", A3="myNMF",
		A4="myNMF", A5="myNMF", A6="myNMF", A7="myNMF"),
	common_iteration=list(A1=30, A2=30, A3=30,
		A4=30, A5=30, A6=30, A7=30),
	common_decomp=list(A1=TRUE, A2=TRUE, A3=TRUE,
		A4=TRUE, A5=TRUE, A6=TRUE, A7=TRUE),
	common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE,
		A4=FALSE, A5=FALSE, A6=FALSE, A7=FALSE),
	common_dims=list(A1=2, A2=2, A3=2, A4=2, A5=2, A6=2, A7=2),
	common_transpose=list(A1=FALSE, A2=FALSE, A3=FALSE,
		A4=FALSE, A5=FALSE, A6=FALSE, A7=FALSE),
	common_coretype="CP",
	# Other option
	specific=FALSE,
	thr=1e-10,
	viz=FALSE,
	verbose=TRUE)

out <- CoupledMWCA(params)

score_At <- t(out@common_factors[["A2"]])
score_Pj <- t(out@common_factors[["A7"]])

# Output
save(out, score_At, score_Pj, file=outfile)
