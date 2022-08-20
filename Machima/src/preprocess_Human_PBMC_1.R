source("src/Functions.R")

# Parameter
outfile1 <- commandArgs(trailingOnly=TRUE)[1]
outfile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile3 <- commandArgs(trailingOnly=TRUE)[3]

# Download
setAnnotationHubOption("CACHE", getwd())
sce <- TENxPBMCData(dataset = "pbmc68k")
td <- tempdir()
destfile <- paste0(td, "/68k_pbmc_barcodes_annotation.tsv")
download.file("https://github.com/10XGenomics/single-cell-3prime-paper/archive/refs/heads/master.zip", destfile=destfile)
unzip(destfile, exdir=td)

# Label
label <- read.delim(
	paste0(td,
	"/single-cell-3prime-paper-master/pbmc68k_analysis/68k_pbmc_barcodes_annotation.tsv"))
label <- label[, "celltype"]

# Random Sampling
idx <- sample(seq(ncol(sce)), 3000)
sce <- sce[, idx]
label <- label[idx]

# Log(CPM + 1)
counts <- as.matrix(assay(sce))
logcpms <- LogCPM(counts)

# NCBI Gene ID <-> Gene Symbol
LtoR <- select(Homo.sapiens,
    column=c("ENSEMBL", "GENEID"),
    keytype="ENSEMBL",
    keys=rownames(logcpms))

# ID Conversion
out <- convertRowID(logcpms, rownames(logcpms), LtoR, aggr.rule="mean")

# Log count matrix
logcpms <- out$output

# Gene Name
gene_names <- rownames(logcpms)

# Save
write.table(logcpms, outfile1,
	row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(gene_names, outfile2,
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, outfile3,
	row.names=FALSE, col.names=FALSE, quote=FALSE)
