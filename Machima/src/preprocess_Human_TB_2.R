source("src/Functions.R")

# Parameter
outfile1 <- commandArgs(trailingOnly=TRUE)[1]
outfile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile3 <- commandArgs(trailingOnly=TRUE)[3]

# Loading
logcpms <- as.matrix(read.csv("data/scRNAseq/Human_PBMC_2/X_RNA.csv",
	header=FALSE))
gene_names <- unlist(read.csv("data/scRNAseq/Human_PBMC_2/GeneNames.csv",
	header=FALSE))
label <- unlist(read.delim("data/scRNAseq/Human_PBMC_2/Label.csv",
	header=FALSE))

# Preprocess
target <- c(
    which(label == "T_cells"),
    which(label == "B_cell"))

logcpms <- logcpms[, target]
label <- label[target]
label[which(label == "T_cells")] <- "T cells"
label[which(label == "B_cell")] <- "B cells"

write.table(logcpms, outfile1,
	row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(gene_names, outfile2,
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, outfile3,
	row.names=FALSE, col.names=FALSE, quote=FALSE)