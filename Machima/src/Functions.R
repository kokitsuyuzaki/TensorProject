library("scRNAseq")
library("HCAData")
library("ExperimentHub")
library("TENxPBMCData")
library("Matrix")
library("celldex")
library("Seurat")
library("R.utils")
# library("SingleCellExperiment")
# library("scater")
# library("scuttle")

options(timeout=1e10)

LogCPM <- function(input){
	libsize <- colSums(input)
	cpm <- median(libsize) * t(t(input) / libsize)
	log10(cpm + 1)
}
