source("src/Functions.R")

# BALF
# Download
td <- tempdir()
destfile1 <- paste0(td, "/nCoV.rds")
destfile2 <- paste0(td, "/all.cell.annotation.meta.txt")
download.file("http://cells.ucsc.edu/covid19-balf/nCoV.rds",
	destfile=destfile1)
download.file("https://raw.githubusercontent.com/zhangzlab/covid_balf/b52be1c50ef79e91bebac82451894942d23b43be/all.cell.annotation.meta.txt",
	destfile=destfile2)

seurat.obj <- readRDS(destfile1)

counts <- as.matrix(seurat.obj@assays$RNA@counts)

label <- read.table(destfile2, header=TRUE)


# ref
# https://www.nature.com/articles/s41591-020-0901-9


