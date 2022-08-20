source("src/Functions.R")

# Parameter
histone <- commandArgs(trailingOnly=TRUE)[1]
bin <- commandArgs(trailingOnly=TRUE)[2]
outfile1 <- commandArgs(trailingOnly=TRUE)[3]
outfile2 <- commandArgs(trailingOnly=TRUE)[4]
outfile3 <- commandArgs(trailingOnly=TRUE)[5]

# input files
infile1 <- paste0("data/scChIPseq/Jurkat_Ramos/Jurkat_Ramos_",
    histone, "_", bin, "/matrix.mtx")
infile2 <- paste0("data/scChIPseq/Jurkat_Ramos/Jurkat_Ramos_",
    histone, "_", bin, "/features.tsv")
infile3 <- paste0("data/scChIPseq/Jurkat_Ramos/Jurkat_Ramos_",
    histone, "_", bin, "/barcodes.tsv")
infile4 <- paste0("data/scChIPseq/Jurkat_Ramos/annotation_",
    histone, ".csv")

# Count matrix
counts <- readMM(infile1)

# Region Names
region_names <- read.table(infile2)[,1]

# Remove zero rows
target <- which(rowSums(counts) != 0)
counts <- as.matrix(counts[target, ])
region_names <- as.matrix(region_names[target])

# Barcodes
annotation <- read.csv(infile4)
barcodes <- as.matrix(read.table(infile3)[,1])
target <- unlist(lapply(barcodes, function(x){
    which(annotation[,1] == x)[1]
}))
label <- annotation[target, 2]

# Save
write.table(counts, file=outfile1,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(region_names, file=outfile2,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(label, file=outfile3,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
