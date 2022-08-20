source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# infile1 = "output/pca/scChIPseq/H3K27me3/50000/output.RData"
# infile2 = "data/scChIPseq/H3K27me3/50000/Label.csv"

# Loading
load(infile1)
label <- unlist(read.delim(infile2, header=FALSE))

# Color Setting
if(length(grep("pseudoBulkChIPseq", infile1)) != 0){
	colvec <- color_ratios
	fill_color <- color_ratios
}else{
	colvec <- color_celltype[label]
	fill_color <- color_celltype[unique(label)]
}

# Plot
png(file=outfile, width=1300, height=1000)
if(length(grep("pca", infile1)) != 0){
	# PCA
	if(ncol(res_dimreduct$x) >= 3){
		pairs(res_dimreduct$x, col=colvec,
			pch=16, cex=2, oma=c(3,3,3,32))
	}else{
		plot(res_dimreduct$x, col=colvec, pch=16, cex=2)
	}
}else{
	# NMF
	if(ncol(res_dimreduct$V) >= 3){
		pairs(res_dimreduct$V, col=colvec,
			pch=16, cex=2, oma=c(3,3,3,32))
	}else{
		plot(res_dimreduct$V, col=colvec, pch=16, cex=2)
	}
}
par(xpd = TRUE)
legend("bottomright",
	fill = fill_color, legend = unique(label))
dev.off()
