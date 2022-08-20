source("src/Functions.R")

# Parameter
sc_sample <- commandArgs(trailingOnly=TRUE)[1]
chip <- commandArgs(trailingOnly=TRUE)[2]
hm <- commandArgs(trailingOnly=TRUE)[3]
bin <- commandArgs(trailingOnly=TRUE)[4]
outfile <- commandArgs(trailingOnly=TRUE)[5]

# File Name Setting
infile1 <- paste0("data/scRNAseq/", sc_sample, "/Label.csv")
chr <- paste0("chr", seq(22))
infiles_1 <- paste0("data/common/scRNAseq/", sc_sample, "/", bin, "/", chr, "/X_RNA.csv")
infiles_2 <- paste0("data/common/", chip, "/", hm, "/", bin, "/", chr, "/X_Epi.csv")
infiles_3 <- paste0("data/common/DistanceT/", hm, "/", bin, "/", chr, "/T.tsv")

# Loading
label_RNA <- unlist(read.delim(infile1, header=FALSE))
X_RNAs <- lapply(infiles_1, function(x){
    as.matrix(read.table(x, header=FALSE))
})
X_Epis <- lapply(infiles_2, function(x){
    as.matrix(read.table(x, header=FALSE))
})
Ts <- lapply(infiles_3, function(x){
    exp(- as.matrix(read.table(x, header=FALSE)) / 500)
})

# Perform Machima
J <- min(length(unique(label_RNA)), ncol(X_RNAs[[1]]), ncol(X_Epis[[1]]))
out <- Machima(X_RNAs, X_Epis, label=label_RNA,
    T=Ts, fixT=TRUE, J=J, verbose=TRUE)

# Save
save(out, file=outfile)