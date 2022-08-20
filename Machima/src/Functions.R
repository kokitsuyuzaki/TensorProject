library("scRNAseq")
library("HCAData")
library("ExperimentHub")
library("TENxPBMCData")
library("Homo.sapiens")
library("Mus.musculus")
library("Matrix")
library("celldex")
library("Seurat")
library("R.utils")
library("devtools")
library("scTGIF")
library("Machima")
library("nnTensor")
library("tagcloud")
library("RColorBrewer")
library("ggplot2")
library("scales")
library("reshape2")
library("igraph")
library("data.table")

options(timeout=1e10)

LogCPM <- function(input){
    libsize <- colSums(input)
    cpm <- median(libsize) * t(t(input) / libsize)
    log10(cpm + 1)
}

# Base Color
green <- brewer.pal(8, "Dark2")[1] # T cells
orange <- brewer.pal(8, "Dark2")[2] # B cells
purple <- brewer.pal(8, "Dark2")[3] # Monocyte
yellow <- brewer.pal(8, "Dark2")[6] # NK
brown <- brewer.pal(8, "Dark2")[7] # Dendritic/DC
gray <- brewer.pal(8, "Dark2")[8] # その他

# Pseudo bulk ChIP-seq
celltypes <- c("Jurkat", "Ramos")
# Orange => Green
ratios <- cbind(seq(0, 10, by=0.5), seq(10, 0, by=-0.5))
color_ratios <- smoothPalette(seq(0, 10, by=0.5),
    palfunc=colorRampPalette(c(orange, "gray", green)))

.pseudoBulk <- function(ratio, celltypes, counts, label, each=100){
    if(ratio[1] != 0){
        idx1 <- sample(which(label == celltypes[1]),
            each*ratio[1], replace=TRUE)
        out1 <- counts[, idx1]
    }else{
        out1 <- rep(0, length=nrow(counts))
    }
    if(ratio[2] != 0){
        idx2 <- sample(which(label == celltypes[2]),
            each*ratio[2], replace=TRUE)
        out2 <- counts[, idx2]
    }else{
        out2 <- rep(0, length=nrow(counts))
    }
    rowMeans(cbind(out1, out2))
}

# Color for celltypes in scRNA-seq
color_celltype <- c(
# scChIPseq
"Jurkat" = green,
"Ramos" = orange,
# bulkChIPseq
"ENCFF291LVP" = brewer.pal(8, "Set1")[1],
"ENCFF259JBE" = brewer.pal(8, "Set1")[2],
"ENCFF619ZKD" = brewer.pal(8, "Set1")[3],
"ENCFF636JEP" = brewer.pal(8, "Set1")[4],
"ENCFF298YTQ" = brewer.pal(8, "Set1")[5],
"ENCFF556EBC" = brewer.pal(8, "Set1")[6],
"ENCFF687HCJ" = brewer.pal(8, "Set1")[7],
"ENCFF165VDC" = brewer.pal(8, "Set1")[8],
# Human_PBMC1
"CD8+ Cytotoxic T" = green,
"CD8+/CD45RA+ Naive Cytotoxic" = gray,
"CD4+/CD45RA+/CD25- Naive T" = green,
"CD4+/CD25 T Reg" = green,
"CD19+ B" = orange,
"CD56+ NK" = yellow,
"CD14+ Monocyte" = purple,
"CD4+/CD45RO+ Memory" = gray,
"Dendritic" = brown,
"CD4+ T Helper2" = green,
"CD34+" = gray,
# Human_PBMC2
"DC" = brown,
"Smooth_muscle_cells" = gray,
"Epithelial_cells" = gray,
"B_cell" = orange,
"Neutrophils" = gray,
"T_cells" = green,
"Monocyte" = purple,
"Erythroblast" = gray,
"BM & Prog." = gray,
"Endothelial_cells" = gray,
"Gametocytes" = gray,
"Neurons" = gray,
"Keratinocytes" = gray,
"HSC_-G-CSF" = gray,
"Macrophage" = gray,
"NK_cell" = yellow,
"Embryonic_stem_cells" = gray,
"Tissue_stem_cells" = gray,
"Chondrocytes" = gray,
"Osteoblasts" = gray,
"BM" = gray,
"Platelets" = gray,
"Fibroblasts" = gray,
"iPS_cells" = gray,
"Hepatocytes" = gray,
"MSC" = gray,
"Neuroepithelial_cell" = gray,
"Astrocyte" = gray,
"HSC_CD34+" = gray,
"CMP" = gray,
"GMP" = gray,
"MEP" = gray,
"Myelocyte" = gray,
"Pre-B_cell_CD34-" = gray,
"Pro-B_cell_CD34+" = gray,
"Pro-Myelocyte" = gray,
# Human_PBMC3
"Neutrophils" = gray,
"Monocytes" = purple,
"HSC" = gray,
"CD4+ T-cells" = green,
"CD8+ T-cells" = green,
"NK cells" = yellow,
"B-cells" = orange,
"Macrophages" = gray,
"Erythrocytes" = gray,
"Endothelial cells" = gray,
"DC" = brown,
"Eosinophils" = gray,
"Chondrocytes" = gray,
"Fibroblasts" = gray,
"Smooth muscle" = gray,
"Epithelial cells" = gray,
"Melanocytes" = gray,
"Skeletal muscle" = gray,
"Keratinocytes" = gray,
"Myocytes" = gray,
"Adipocytes" = gray,
"Neurons" = gray,
"Pericytes" = gray,
"Astrocytes" = gray,
"Mesangial cells" = gray,
# Human_PBMC4
"B cells" = orange,
"Monocytes" = purple,
"NK cells" = yellow,
"T cells, CD4+" = green,
"T cells, CD8+" = green,
# Human_PBMC5
"NK T cells" = gray,
"CD8+ T cells" = green,
"CD4+ T cells" = green,
"B cells" = orange,
"Basophils" = gray,
"CMPs" = gray,
"Dendritic cells" = brown,
"Eosinophils" = gray,
"Erythroid cells" = gray,
"GMPs" = gray,
"Granulocytes" = gray,
"HSCs" = gray,
"Megakaryocytes" = gray,
"MEPs" = gray,
"Monocytes" = purple,
"NK cells" = yellow,
# Human_PBMC6
"T cells" = green,
"B cells" = orange,
"CD8+ T cells" = green,
"CD4+ T cells" = green,
"Progenitors" = gray,
"Monocytes" = purple,
"NK cells" = yellow,
"Dendritic cells" = brown,
"Neutrophils" = gray,
"Basophils" = gray,
# Human_TB_2/Human_TB_6
"T cells" = green,
"B cells" = orange
)