source("src/Functions.R")

# Download
destfile <- paste0(tempdir(), "GSE29087_L139_expression_tab.txt.gz")
download.file("https://ftp.ncbi.nlm.nih.gov/geo/series/GSE29nnn/GSE29087/suppl/GSE29087%5FL139%5Fexpression%5Ftab%2Etxt%2Egz",
	destfile=destfile)

# Preprocess
counts <- read.table(destfile,
	colClasses=c(list("character", NULL, NULL, NULL, NULL, NULL, NULL),
	rep("integer", 96)),
	skip=6, sep='\t', row.names=1)
counts <- counts[, seq(92)]

# Transform
is.mito <- grep("mt-", rownames(counts))
is.spike <- grep("SPIKE", rownames(counts))
is.r <- grep("r_", rownames(counts))
target <- setdiff(seq(nrow(counts)), is.mito)
target <- setdiff(target, is.spike)
target <- setdiff(target, is.r)
counts <- counts[target, ]

# Log(CPM + 1)
counts <- as.matrix(counts)
logcpm <- LogCPM(counts)

# Gene Names
genenames <- rownames(logcpm)

# Label
label <- rep(c("mESC", "MEF"), c(48, 44))

# Save
write.table(logcpm, "data/scRNAseq/Mouse_ESC_1/X_RNA.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(genenames, "data/scRNAseq/Mouse_ESC_1/GeneNames.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, "data/scRNAseq/Mouse_ESC_1/Label.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)

# ref
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5112579/pdf/f1000research-5-10712.pdf
# https://bioconductor.riken.jp/packages/3.8/workflows/vignettes/simpleSingleCell/inst/doc/xtra-2-spike.html