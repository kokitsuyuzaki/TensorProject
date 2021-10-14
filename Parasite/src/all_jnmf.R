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

# jNMF-type decomposition
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
	# Specific Factor Matrices
	specific_model=list(
		At_logTPM=list(J1="B1", J2="B2"),
		Y_At_time=list(J3="B3", J4="B4"),
		Y_At_wol=list(J5="B5", J6="B6"),
		Y_At_parasm=list(J7="B7", J8="B8"),
		Pj_logTPM=list(J9="B9", J10="B10"),
		Y_Pj_time=list(J11="B11", J12="B12"),
		Y_Pj_wol=list(J13="B13", J14="B14"),
		Y_Pj_parasm=list(J15="B15", J16="B16")),
	specific_initial=list(B1=NULL, B2=NULL, B3=NULL, B4=NULL,
		B5=NULL, B6=NULL, B7=NULL, B8=NULL,
		B9=NULL, B10=NULL, B11=NULL, B12=NULL,
		B13=NULL, B14=NULL, B15=NULL, B16=NULL),
	specific_algorithms=list(B1="myNMF", B2="myNMF", B3="myNMF", B4="myNMF",
		B5="myNMF", B6="myNMF", B7="myNMF", B8="myNMF",
		B9="myNMF", B10="myNMF", B11="myNMF", B12="myNMF",
		B13="myNMF", B14="myNMF", B15="myNMF", B16="myNMF"),
	specific_iteration=list(B1=30, B2=30, B3=30, B4=30,
		B5=30, B6=30, B7=30, B8=30,
		B9=30, B10=30, B11=30, B12=30,
		B13=30, B14=30, B15=30, B16=30),
	specific_decomp=list(B1=TRUE, B2=TRUE, B3=TRUE, B4=TRUE,
		B5=TRUE, B6=TRUE, B7=TRUE, B8=TRUE,
		B9=TRUE, B10=TRUE, B11=TRUE, B12=TRUE,
		B13=TRUE, B14=TRUE, B15=TRUE, B16=TRUE),
	specific_fix=list(B1=FALSE, B2=FALSE, B3=FALSE, B4=FALSE,
		B5=FALSE, B6=FALSE, B7=FALSE, B8=FALSE,
		B9=FALSE, B10=FALSE, B11=FALSE, B12=FALSE,
		B13=FALSE, B14=FALSE, B15=FALSE, B16=FALSE),
	specific_dims=list(B1=2, B2=2, B3=2, B4=2,
		B5=2, B6=2, B7=2, B8=2,
		B9=2, B10=2, B11=2, B12=2,
		B13=2, B14=2, B15=2, B16=2),
	specific_transpose=list(B1=FALSE, B2=FALSE, B3=FALSE, B4=FALSE,
		B5=FALSE, B6=FALSE, B7=FALSE, B8=FALSE,
		B9=FALSE, B10=FALSE, B11=FALSE, B12=FALSE,
		B13=FALSE, B14=FALSE, B15=FALSE, B16=FALSE),
	specific_coretype="CP",
	# Other option
	specific=TRUE,
	thr=1e-10,
	viz=FALSE,
	verbose=TRUE)

out <- CoupledMWCA(params)

score_At <- t(out@common_factors[["A2"]])
score_Pj <- t(out@common_factors[["A7"]])

# Output
save(out, score_At, score_Pj, file=outfile)
