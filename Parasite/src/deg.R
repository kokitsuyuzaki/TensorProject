source("src/functions.R")
load("data/objects.RData")

# Parameter
species <- commandArgs(trailingOnly=TRUE)[1]
degs <- commandArgs(trailingOnly=TRUE)[2]
outfile1 <- commandArgs(trailingOnly=TRUE)[3]
outfile2 <- commandArgs(trailingOnly=TRUE)[4]

# Preprocessing
if(species == "at"){
	tpm <- At_logTPM
}
if(species == "pj"){
	tpm <- Pj_logTPM
}

# Group Index
# At
if((species == "at") && (degs == "1d")){
	index1 <- which(Y_At_time[,1] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}
if((species == "at") && (degs == "3d")){
	index1 <- which(Y_At_time[,2] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}
if((species == "at") && (degs == "7d")){
	index1 <- which(Y_At_time[,3] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}
if((species == "at") && (degs == "wol")){
	index1 <- which(Y_At_wol[,1] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}
if((species == "at") && (degs == "parasm")){
	index1 <- which(Y_At_parasm[,1] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}

# Pj
if((species == "pj") && (degs == "1d")){
	index1 <- which(Y_Pj_time[,1] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}
if((species == "pj") && (degs == "3d")){
	index1 <- which(Y_Pj_time[,2] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}
if((species == "pj") && (degs == "7d")){
	index1 <- which(Y_Pj_time[,3] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}
if((species == "pj") && (degs == "wol")){
	index1 <- which(Y_Pj_wol[,1] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}
if((species == "pj") && (degs == "parasm")){
	index1 <- which(Y_Pj_parasm[,1] == 1)
	index2 <- setdiff(seq(ncol(tpm)), index1)
}

# t-test
p <- apply(tpm, 1, function(x){
	group1 <- x[index1]
	group2 <- x[index2]
	t.test(x=group1, y=group2)$p.value
})

# multiple test correction
q <- p.adjust(p, "BH")

# Save
save(p, file=outfile1)
save(q, file=outfile2)
