source("src/Functions.R")

# Download
destfile <- paste0(tempdir(), "GSE149938_umi_matrix.csv.gz")
download.file("https://ftp.ncbi.nlm.nih.gov/geo/series/GSE149nnn/GSE149938/suppl/GSE149938%5Fumi%5Fmatrix%2Ecsv%2Egz",
	destfile=destfile)

# Preprocess
counts <- read.table(destfile, sep=",")
counts <- t(counts)

# Transform
is.ercc <- grep("ERCC", rownames(counts))
target <- setdiff(seq(nrow(counts)), is.ercc)
counts <- counts[target, ]

# Log(CPM + 1)
logcpm <- LogCPM(counts)

# Gene Names
genenames <- rownames(logcpm)

# Label
label <- unlist(lapply(colnames(counts), function(x){strsplit(x, "_")[[1]][1]}))
label[label %in% c("HSC", "MPP", "CMP", "MEP", "LMPP", "MLP", "BNK", "GMP")] <- "HSPC"
label[label %in% c("proB", "preB", "immB", "regB", "naiB", "memB", "plasma")] <- "B"
label[label %in% c("CLP", "NKP", "toxiNK", "kineNK")] <- "NK"
label[label %in% c("CD4T", "CD8T")] <- "T"
label[label %in% c("hMDP", "cMOP", "preM", "claM", "interM", "nonM")] <- "Monocyte"
label[label %in% c("proN", "myeN", "metaN", "matureN")] <- "Neutrophil"
label[label %in% c("ery")] <- "Erythrocyte"

# Save
write.table(logcpm, "data/scRNAseq/Human_BloodAtlas_1/X_RNA.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(genenames, "data/scRNAseq/Human_BloodAtlas_1/GeneNames.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, "data/scRNAseq/Human_BloodAtlas_1/Label.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)