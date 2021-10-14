# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# Data
Xs <- list(At_logTPM=At_logTPM, Y_At_time=Y_At_time,
	Y_Pj_time=Y_Pj_time, Pj_logTPM=Pj_logTPM)

# jNMF-type decomposition
params <- new("CoupledMWCAParams",
	# Data-wise setting
	Xs=Xs,
	mask=list(At_logTPM=NULL, Y_At_time=NULL,
	Y_Pj_time=NULL, Pj_logTPM=NULL),
	weights=list(At_logTPM=1, Y_At_time=1,
	Y_Pj_time=1, Pj_logTPM=1),
	# Common Factor Matrices
	common_model=list(
		At_logTPM=list(I1="A1", I2="A2"),
		Y_At_time=list(I2="A2", I3="A3"),
		Y_Pj_time=list(I4="A4", I3="A3"),
		Pj_logTPM=list(I5="A5", I4="A4")),
	common_initial=list(A1=NULL, A2=NULL, A3=NULL, A4=NULL, A5=NULL),
	common_algorithms=list(A1="myNMF", A2="myNMF", A3="myNMF",
		A4="myNMF", A5="myNMF"),
	common_iteration=list(A1=30, A2=30, A3=30, A4=30, A5=30),
	common_decomp=list(A1=TRUE, A2=TRUE, A3=TRUE, A4=TRUE, A5=TRUE),
	common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE, A5=FALSE),
	common_dims=list(A1=3, A2=3, A3=3, A4=3, A5=3),
	common_transpose=list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE, A5=FALSE),
	common_coretype="CP",
	# Specific Factor Matrices
	specific_model=list(
		At_logTPM=list(J1="B1", J2="B2"),
		Y_At_time=list(J3="B3", J4="B4"),
		Y_Pj_time=list(J5="B5", J6="B6"),
		Pj_logTPM=list(J7="B7", J8="B8")),
	specific_initial=list(B1=NULL, B2=NULL, B3=NULL, B4=NULL,
		B5=NULL, B6=NULL, B7=NULL, B8=NULL),
	specific_algorithms=list(B1="myNMF", B2="myNMF", B3="myNMF", B4="myNMF",
		B5="myNMF", B6="myNMF", B7="myNMF", B8="myNMF"),
	specific_iteration=list(B1=30, B2=30, B3=30, B4=30,
		B5=30, B6=30, B7=30, B8=30),
	specific_decomp=list(B1=TRUE, B2=TRUE, B3=TRUE, B4=TRUE,
		B5=TRUE, B6=TRUE, B7=TRUE, B8=TRUE),
	specific_fix=list(B1=FALSE, B2=FALSE, B3=FALSE, B4=FALSE,
		B5=FALSE, B6=FALSE, B7=FALSE, B8=FALSE),
	specific_dims=list(B1=3, B2=3, B3=3, B4=3,
		B5=3, B6=3, B7=3, B8=3),
	specific_transpose=list(B1=FALSE, B2=FALSE, B3=FALSE, B4=FALSE,
		B5=FALSE, B6=FALSE, B7=FALSE, B8=FALSE),
	specific_coretype="CP",
	# Other option
	specific=TRUE,
	thr=1e-10,
	viz=FALSE,
	verbose=TRUE)

out <- CoupledMWCA(params)

score_At <- t(out@common_factors[["A2"]])
score_Pj <- t(out@common_factors[["A4"]])

# Output
save(out, score_At, score_Pj, file=outfile)
