source("src/Functions.R")

# Parameter
histone <- commandArgs(trailingOnly=TRUE)[1]
bin <- commandArgs(trailingOnly=TRUE)[2]
outfile1 <- commandArgs(trailingOnly=TRUE)[3]
outfile2 <- commandArgs(trailingOnly=TRUE)[4]
outfile3 <- commandArgs(trailingOnly=TRUE)[5]

# input files
if(histone == "H3K27me3"){
    ids <- c("ENCFF291LVP", "ENCFF259JBE", "ENCFF619ZKD", "ENCFF636JEP")
}
if(histone == "H3K4me3"){
    ids <- c("ENCFF298YTQ", "ENCFF556EBC", "ENCFF687HCJ", "ENCFF165VDC")
}
label <- paste0("data/bulkChIPseq/", ids, ".bed.sorted.", bin, ".bin")

# Count matrix
matrices <- lapply(label, function(x){
    read.table(x, header=FALSE)
})
counts <- t(do.call(rbind, lapply(matrices, function(x){x[,4]})))

# Region Names
region_names <- apply(matrices[[1]], 1, function(x){
	xx <- gsub(" ", "", x)
	paste0(xx[1:3], collapse="_")
})

# Remove zero rows
target <- which(rowSums(counts) != 0)
counts <- counts[target, ]
region_names <- as.matrix(region_names[target])
ids <- as.matrix(ids)

# Save
write.table(counts, file=outfile1,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(region_names, file=outfile2,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(ids, file=outfile3,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
