# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]

# infile1 <- 'data/scRNAseq/Human_PBMC_2/chr2/X_RNA.csv'
# infile2 <- 'data/scRNAseq/Human_PBMC_2/chr2/GeneNames.csv'
# infile3 <- 'data/common/5000/chr2/GeneNames.tsv'

# Loading
mat <- as.matrix(read.csv(infile1, header=FALSE))
old_ids <- as.character(unlist(read.delim(infile2, header=FALSE)))
new_ids <- as.character(unlist(read.delim(infile3, header=FALSE)))

# Filtering
out <- matrix(0, nrow=length(new_ids), ncol=ncol(mat))
rownames(out) <- new_ids
out[old_ids, ] <- mat

# Save
write.table(out, outfile, row.names=FALSE, col.names=FALSE, quote=FALSE)
