source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
outfile1 <- commandArgs(trailingOnly=TRUE)[4]
outfile2 <- commandArgs(trailingOnly=TRUE)[5]

# infile1 = "output/machima/Human_PBMC_1/bulkChIPseq/H3K4me3/5000/output.RData"
# infile2 = "data/scRNAseq/Human_PBMC_1/Label.csv"
# infile3 = "data/bulkChIPseq/H3K4me3/5000/Label.csv"

# Loading
load(infile1)
label <- unlist(read.delim(infile2, header=FALSE))
label2 <- unlist(read.delim(infile3, header=FALSE))

# Color Setting for RNA
colvec <- color_celltype[label]
fill_color <- color_celltype[unique(label)]

# Color Setting for Epi
if(length(grep("pseudoBulkChIPseq", infile3)) != 0){
	colvec2 <- color_ratios
	fill_color2 <- color_ratios
}
if(length(grep("bulkChIPseq", infile3)) != 0){
	colvec2 <- color_celltype[label2]
	fill_color2 <- color_celltype[unique(label2)]
}

# Setting dimension
nr <- nrow(out$H_RNA)
newdim <- min(10, nr)

# Plot（H_RNA）
png(file=outfile1, width=1300, height=1000)
if(nr >= 3){
	pairs(t(out$H_RNA[seq(newdim), ]), col=colvec,
		pch=16, cex=2, oma=c(3,3,3,32))
}else{
	plot(t(out$H_RNA), col=colvec, pch=16, cex=2)
}
par(xpd = TRUE)
legend("bottomright", fill = fill_color, legend = unique(label))
dev.off()

# Plot（H_Epi）
png(file=outfile2, width=1300, height=1000)
if(length(grep("pseudoBulkChIPseq", infile1)) != 0){
	outH <- rbind(out$H_Epi[seq(newdim), ], ratios[,1])
	rownames(outH)[nrow(outH)] <- "Jurkat:Ramos"
	pairs(t(outH), col=colvec2, pch=16, cex=2, oma=c(3,3,3,32))
}else{
	if(nrow(out$H_Epi) >= 3){
		pairs(t(out$H_Epi), col=colvec2, pch=16, cex=2, oma=c(3,3,3,32))
	}else{
		plot(t(out$H_Epi[1:2,]), col=seq(ncol(out$H_Epi)), pch=16, cex=2)
	}
}
par(xpd = TRUE)
legend("bottomright",
	fill = fill_color2, legend = unique(label2))
dev.off()
