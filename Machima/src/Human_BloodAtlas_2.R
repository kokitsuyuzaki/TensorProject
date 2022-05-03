source("src/Functions.R")

# Download
destfile <- paste0(tempdir(), "GSM4850578_Blood_Counts.csv.gz")
download.file("https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4850nnn/GSM4850578/suppl/GSM4850578%5FBlood%5FCounts%2Ecsv%2Egz",
	destfile=destfile)

destfile2 <- paste0(tempdir(), "Annotation_AHCA_alltissues_meta.data_84363_cell.txt")
download.file("https://raw.githubusercontent.com/bei-lab/scRNA-AHCA/master/Cell_barcode_and_corresponding_cell_types_of_AHCA/Annotation_AHCA_alltissues_meta.data_84363_cell.txt",
	destfile=destfile2)

# Preprocess
counts <- as.matrix(read.table(destfile, sep=","))

# Transform
is.mit <- grep("MT-", rownames(counts))
is.ercc <- grep("ERCC", rownames(counts))
target <- setdiff(seq(nrow(counts)), is.mit)
target <- setdiff(target, is.ercc)
counts <- counts[target, ]

# Log(CPM + 1)
logcpm <- LogCPM(counts)

# Gene Names
genenames <- rownames(logcpm)

# Label
label <- read.delim(destfile2, header=TRUE, row.names=1, sep="\t")
label <- label[grep("Blood_", rownames(label)), ]
label <- label[,"Cell_type_in_each_tissue"]

# Save
write.table(logcpm, "data/scRNAseq/Human_BloodAtlas_2/X_RNA.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(genenames, "data/scRNAseq/Human_BloodAtlas_2/GeneNames.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, "data/scRNAseq/Human_BloodAtlas_2/Label.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)