source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]

# infile1 = 'output/machima/Human_PBMC_1/pseudoBulkChIPseq/H3K27me3/50000/output.RData'
# infile2 = 'data/scRNAseq/Human_PBMC_1/Label.csv'
# infile3 = 'data/pseudoBulkChIPseq/H3K27me3/50000/Label.csv'

# Loading
load(infile1)
label <- unlist(read.delim(infile2, header=FALSE))
label2 <- unlist(read.delim(infile3, header=FALSE))

# Normalization of H_Epi
normH <- t(t(out$H_Epi) / colSums(out$H_Epi)) * 100
colnames(normH) <- label2

# Color Setting
fill_color <- color_celltype[unique(label)]

# Preprocessing
gdata <- melt(normH)
colnames(gdata) <- c("Celltype", "Ratio", "Percent")

# 重ね合わせ棒グラフ（Admixture風）
g <- ggplot(gdata, aes(x=Ratio, y=Percent, fill=Celltype))
g <- g + geom_bar(stat = "identity", position = "fill")
g <- g + scale_y_continuous(labels = percent)
g <- g + scale_fill_manual(values = fill_color)
g <- g + theme(axis.text.x = element_text(angle = -45, hjust = 0))
g <- g + theme(axis.title.x = element_blank())

# Save
ggsave(file=outfile, plot=g, dpi=100, width=10, height=6)
