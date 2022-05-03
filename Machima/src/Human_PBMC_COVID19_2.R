source("src/Functions.R")

# Download
destfile <- paste0(tempdir(), "/post_align_object.rds.gz")
download.file("http://junglab.kaist.ac.kr/Dataset/post_align_object.rds.gz",
	destfile=destfile)
gunzip(destfile)
seurat.obj <- readRDS(gsub(".gz", "", destfile))

# Preprocess
counts_hc <- seurat.obj[, which(seurat.obj$disease == "HC")]
counts_flu <- seurat.obj[, which(seurat.obj$disease == "Flu")]
counts_cov_mild <- seurat.obj[, which(seurat.obj$disease == "nCoV.mild")]
counts_cov_severe <- seurat.obj[, which(seurat.obj$disease == "nCoV.sev")]

# Transform
is.ercc <- grep("ERCC", rownames(counts_hc))
target <- setdiff(seq(nrow(counts_hc)), is.ercc)
counts_hc <- counts_hc[target, ]
counts_flu <- counts_flu[target, ]
counts_cov_mild <- counts_cov_mild[target, ]
counts_cov_severe <- counts_cov_severe[target, ]

# Log(CPM + 1)
counts_hc <- as.matrix(counts_hc@assays$RNA@counts)
counts_flu <- as.matrix(counts_flu@assays$RNA@counts)
counts_cov_mild <- as.matrix(counts_cov_mild@assays$RNA@counts)
counts_cov_severe <- as.matrix(counts_cov_severe@assays$RNA@counts)

logcpm_hc <- LogCPM(counts_hc)
logcpm_flu <- LogCPM(counts_flu)
logcpm_cov_mild <- LogCPM(counts_cov_mild)
logcpm_cov_severe <- LogCPM(counts_cov_severe)

# Gene Names
genenames <- rownames(logcpm_hc)

# Label
label <- seurat.obj@active.ident










# Save
write.table(logcpm, "data/scRNAseq/Mouse_ESC_2/X_RNA.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)

write.table(genenames, "data/scRNAseq/Mouse_ESC_2/GeneNames.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, "data/scRNAseq/Mouse_ESC_2/Label.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)