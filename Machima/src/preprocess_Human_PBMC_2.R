source("src/Functions.R")

# Parameter
outfile1 <- commandArgs(trailingOnly=TRUE)[1]
outfile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile3 <- commandArgs(trailingOnly=TRUE)[3]

# Download
setAnnotationHubOption("CACHE", getwd())
sce <- HumanPrimaryCellAtlasData()

# Preprocess
logcounts <- assays(sce)@listData$logcounts
is.noname <- grep("NONAME", rownames(logcounts))
is.ercc <- grep("ERCC", rownames(logcounts))
target <- setdiff(seq(nrow(logcounts)), is.noname)
target <- setdiff(target, is.ercc)
logcounts <- logcounts[target, ]

# NCBI Gene ID <-> Gene Symbol
LtoR <- select(Homo.sapiens,
    column=c("SYMBOL", "GENEID"),
    keytype="SYMBOL",
    keys=rownames(logcounts))

# ID Conversion
out <- convertRowID(logcounts, rownames(logcounts), LtoR, aggr.rule="mean")

# Log count matrix
logcounts <- out$output

# Gene Name
gene_names <- rownames(logcounts)

# Label
label <- colData(sce)$label.main

# Save
write.table(logcounts, outfile1,
	row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(gene_names, outfile2,
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, outfile3,
	row.names=FALSE, col.names=FALSE, quote=FALSE)
