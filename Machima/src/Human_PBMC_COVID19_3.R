source("src/Functions.R")

# Download
destfile <- paste0(tempdir(), "/blish_covid.seu.rds")
download.file("https://hosted-matrices-prod.s3-us-west-2.amazonaws.com/Single_cell_atlas_of_peripheral_immune_response_to_SARS_CoV_2_infection-25/blish_covid.seu.rds",
	destfile=destfile)
seurat.obj <- readRDS(destfile)

# より大規模なデータもくれた
# https://rupress.org/jem/article/218/8/e20210582/212379/Multi-omic-profiling-reveals-widespread
# https://covid19.cog.sanger.ac.uk/submissions/release1/blish_awilk_covid_seurat.rds

# 患者ID:
table(unlist(lapply(colnames(seurat.obj),
	function(x){strsplit(x, "\\.")[[1]][1]})))

# 細胞型ラベル
table(seurat.obj@meta.data$cell.type.coarse)
