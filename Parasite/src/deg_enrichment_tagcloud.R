source("src/functions.R")

# Parameter
m <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Output directory
dir.create(paste0("plot/enrichment/", m), recursive=TRUE)

# Color Setting
palf <- colorRampPalette(c("blue", "grey", "red"))

# No. of files
numFiles <- length(grep("At_BP_pos",
	list.files(paste0("output/enrichment/", m))))

# Enrichment Analysis Setting
GOType <- c("BP", "MF", "CC")

# Enrichment Analysis (At)
for(i in seq(numFiles)){
	for(j in seq(3)){
		# Roading
		infileGO_pos <- paste0("output/enrichment/", m, "/At_", GOType[j], "_pos", i, ".txt")
		infileGO_neg <- paste0("output/enrichment/", m, "/At_", GOType[j], "_neg", i, ".txt")
		GO_pos <- read.delim(infileGO_pos, header=TRUE, sep="\t")
		GO_neg <- read.delim(infileGO_neg, header=TRUE, sep="\t")
		if(nrow(GO_pos) != 0){
			GO_pos$Qvalue[which(GO_pos$Qvalue == 0)] <- 1E-100
			colorsGO_pos <- smoothPalette(-log10(GO_pos$Qvalue), palfunc=palf)
			outfileGO_pos <- paste0("plot/enrichment/", m, "/At_", GOType[j], "_pos", i, ".png")
			# Plot (Positive)
			png(file=outfileGO_pos, width=1000, height=1000)
			if(length(GO_pos$Qvalue) != 1){
				tagcloud(GO_pos$GOTerm, weights=-log10(GO_pos$Qvalue), col=colorsGO_pos,
					order="size", algorithm="fill", scale.multiplier=0.8)
			}else{
				.SinglePlot(GO_pos$GOTerm)
			}
			dev.off()
		}
		if(nrow(GO_neg) != 0){
			GO_neg$Qvalue[which(GO_neg$Qvalue == 0)] <- 1E-100
			colorsGO_neg <- smoothPalette(-log10(GO_neg$Qvalue), palfunc=palf)
			outfileGO_neg <- paste0("plot/enrichment/", m, "/At_", GOType[j], "_neg", i, ".png")
			# Plot (Negative)
			png(file=outfileGO_neg, width=1000, height=1000)
			if(length(GO_neg$Qvalue) != 1){
				tagcloud(GO_neg$GOTerm, weights=-log10(GO_neg$Qvalue), col=colorsGO_neg,
					order="size", algorithm="fill", scale.multiplier=0.8)
			}else{
				.SinglePlot(GO_neg$GOTerm)
			}
			dev.off()
		}
	}
}

# Enrichment Analysis (Pj)
for(i in seq(numFiles)){
	for(j in seq(3)){
		# Roading
		infileGO_pos <- paste0("output/enrichment/", m, "/Pj_", GOType[j], "_pos", i, ".txt")
		infileGO_neg <- paste0("output/enrichment/", m, "/Pj_", GOType[j], "_neg", i, ".txt")
		GO_pos <- read.delim(infileGO_pos, header=TRUE, sep="\t")
		GO_neg <- read.delim(infileGO_neg, header=TRUE, sep="\t")
		if(nrow(GO_pos) != 0){
			GO_pos$Qvalue[which(GO_pos$Qvalue == 0)] <- 1E-100
			colorsGO_pos <- smoothPalette(-log10(GO_pos$Qvalue), palfunc=palf)
			outfileGO_pos <- paste0("plot/enrichment/", m, "/Pj_", GOType[j], "_pos", i, ".png")
			# Plot (Positive)
			png(file=outfileGO_pos, width=1000, height=1000)
			if(length(GO_pos$Qvalue) != 1){
				tagcloud(GO_pos$GOTerm, weights=-log10(GO_pos$Qvalue), col=colorsGO_pos,
					order="size", algorithm="fill", scale.multiplier=0.8)
			}else{
				.SinglePlot(GO_pos$GOTerm)
			}
			dev.off()
		}
		if(nrow(GO_neg) != 0){
			GO_neg$Qvalue[which(GO_neg$Qvalue == 0)] <- 1E-100
			colorsGO_neg <- smoothPalette(-log10(GO_neg$Qvalue), palfunc=palf)
			outfileGO_neg <- paste0("plot/enrichment/", m, "/Pj_", GOType[j], "_neg", i, ".png")
			# Plot (Negative)
			png(file=outfileGO_neg, width=1000, height=1000)
			if(length(GO_neg$Qvalue) != 1){
				tagcloud(GO_neg$GOTerm, weights=-log10(GO_neg$Qvalue), col=colorsGO_neg,
					order="size", algorithm="fill", scale.multiplier=0.8)
			}else{
				.SinglePlot(GO_neg$GOTerm)
			}
			dev.off()
		}
	}
}

# Output
file.create(outfile)
