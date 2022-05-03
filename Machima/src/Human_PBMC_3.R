source("src/Functions.R")

# Download
sce <- BlueprintEncodeData()

# Preprocess
logcounts <- assays(sce)@listData$logcounts

# Transform
is.ercc <- grep("ERCC", rownames(logcounts))
target <- setdiff(seq(nrow(logcounts)), is.ercc)
logcounts <- logcounts[target, ]

# Gene Names
genenames <- rownames(logcounts)

# Label
label <- colData(sce)$label.main

# Save
write.table(logcpm, "data/scRNAseq/Human_PBMC_3/X_RNA.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(genenames, "data/scRNAseq/Human_PBMC_3/GeneNames.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, "data/scRNAseq/Human_PBMC_3/Label.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)