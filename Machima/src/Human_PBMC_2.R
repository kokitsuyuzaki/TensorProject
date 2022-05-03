source("src/Functions.R")

# Download
sce <- HumanPrimaryCellAtlasData()

# Preprocess
logcounts <- assays(sce)@listData$logcounts

# Transform
is.noname <- grep("NONAME", rownames(logcounts))
is.ercc <- grep("ERCC", rownames(logcounts))
target <- setdiff(seq(nrow(logcounts)), is.noname)
target <- setdiff(target, is.ercc)
logcounts <- logcounts[target, ]

# Gene Names
genenames <- rownames(logcounts)

# Label
label <- colData(sce)$label.main

# Save
write.table(logcpm, "data/scRNAseq/Human_PBMC_2/X_RNA.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(genenames, "data/scRNAseq/Human_PBMC_2/GeneNames.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, "data/scRNAseq/Human_PBMC_2/Label.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)