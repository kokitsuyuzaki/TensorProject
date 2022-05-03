source("src/Functions.R")

# Download
sce <- TENxPBMCData(dataset = "pbmc68k")
td <- tempdir()
destfile <- paste0(td, "/68k_pbmc_barcodes_annotation.tsv")
download.file("https://github.com/10XGenomics/single-cell-3prime-paper/archive/refs/heads/master.zip", destfile=destfile)
unzip(destfile, exdir=td)

# Preprocess
counts <- as.matrix(counts(sce))
colnames(counts) <- colData(sce)[,"Barcode"]

# Gene Names
genenames <- rowData(sce)[,"Symbol_TENx"]

# Label
label <- read.delim(
	paste0(td,
	"/single-cell-3prime-paper-master/pbmc68k_analysis/68k_pbmc_barcodes_annotation.tsv"))
label <- label[, "celltype"]

# Random Sampling
idx <- sample(seq(ncol(counts)), 3000)
counts <- counts[, idx]
label <- label[idx]

# Log(CPM + 1)
counts <- as.matrix(counts)
logcpm <- LogCPM(counts)

# Save
write.table(logcpm, "data/scRNAseq/Human_PBMC_1/X_RNA.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(genenames, "data/scRNAseq/Human_PBMC_1/GeneNames.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, "data/scRNAseq/Human_PBMC_1/Label.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)