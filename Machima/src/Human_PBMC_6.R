source("src/Functions.R")

# Download
sce <- MonacoImmuneData()

# Preprocess
logcounts <- assays(sce)@listData$logcounts

# Transform
is.mit <- grep("^MT-", rownames(logcounts))
is.ercc <- grep("ERCC", rownames(logcounts))
target <- setdiff(seq(nrow(logcounts)), is.mit)
target <- setdiff(target, is.ercc)
logcounts <- logcounts[target, ]

# Gene Names
genenames <- rownames(logcounts)

# Label
label <- colData(sce)$label.main

# Save
write.table(logcpm, "data/scRNAseq/Human_PBMC_6/X_RNA.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(genenames, "data/scRNAseq/Human_PBMC_6/GeneNames.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, "data/scRNAseq/Human_PBMC_6/Label.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)