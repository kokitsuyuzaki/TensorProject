source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
chromosome <- commandArgs(trailingOnly=TRUE)[4]
outfile1 <- commandArgs(trailingOnly=TRUE)[5]
outfile2 <- commandArgs(trailingOnly=TRUE)[6]
outfile3 <- commandArgs(trailingOnly=TRUE)[7]

# Loading
logcounts <- read.csv(infile1, header=FALSE)
gene_names <- unlist(read.csv(infile2, header=FALSE))
label <- read.delim(infile3, header=FALSE)

# Stratification
tmp <- select(Homo.sapiens,
    columns=c("CDSCHROM", "GENEID"),
    keytype="GENEID", keys=gene_names)
tmp <- tmp[which(!is.na(tmp$CDSCHROM)), ]

target_gene_names <- sort(tmp[which(tmp$CDSCHROM == chromosome), "GENEID"])
target_position <- sapply(target_gene_names, function(x){
	which(gene_names == x)
})

logcounts <- logcounts[target_position, ]
gene_names <- gene_names[target_position]

# Save
write.table(logcounts, outfile1,
	row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(gene_names, outfile2,
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, outfile3,
	row.names=FALSE, col.names=FALSE, quote=FALSE)
