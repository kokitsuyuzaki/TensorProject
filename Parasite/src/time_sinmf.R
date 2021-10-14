# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# Data
Xs <- list(At_logTPM=At_logTPM, Y_At_time=Y_At_time,
	Y_Pj_time=Y_Pj_time, Pj_logTPM=Pj_logTPM)

# siNMF-type decomposition
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
	# Other option
	specific=FALSE,
	thr=1e-10,
	viz=FALSE,
	verbose=TRUE)

out <- CoupledMWCA(params)

score_At <- t(out@common_factors[["A2"]])
score_Pj <- t(out@common_factors[["A4"]])

# Output
save(out, score_At, score_Pj, file=outfile)
