# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
infile4 <- commandArgs(trailingOnly=TRUE)[4]
infile5 <- commandArgs(trailingOnly=TRUE)[5]
outfile <- commandArgs(trailingOnly=TRUE)[6]

# infile1 <- 'data/DistanceT/5000/chr1/T.tsv'
# infile2 <- 'data/DistanceT/5000/chr1/RegionNames.tsv'
# infile3 <- 'data/common/H3K27me3/5000/chr1/RegionNames.csv'
# infile4 <- 'data/DistanceT/5000/chr1/GeneNames.tsv'
# infile5 <- 'data/common/5000/chr1/GeneNames.tsv'

# Loading
mat <- as.matrix(read.csv(infile1, header=FALSE))
old_row_ids <- as.character(unlist(read.delim(infile2, header=FALSE)))
new_row_ids <- as.character(unlist(read.delim(infile3, header=FALSE)))
old_column_ids <- as.character(unlist(read.delim(infile4, header=FALSE)))
new_column_ids <- as.character(unlist(read.delim(infile5, header=FALSE)))

# Filtering
out <- matrix(0, nrow=length(new_row_ids), ncol=length(new_column_ids))
rownames(out) <- new_row_ids
colnames(out) <- new_column_ids
out[old_row_ids, old_column_ids] <- mat

# Save
write.table(out, outfile, row.names=FALSE, col.names=FALSE, quote=FALSE)
