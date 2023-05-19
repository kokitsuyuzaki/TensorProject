source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
infile4 <- args[4]

infile5 <- args[5]
infile6 <- args[6]
infile7 <- args[7]
infile8 <- args[8]

infile9 <- args[9]
infile10 <- args[10]
infile11 <- args[11]
infile12 <- args[12]

infile13 <- args[13]
infile14 <- args[14]
infile15 <- args[15]
infile16 <- args[16]

outfile1 <- args[17]
outfile2 <- args[18]
outfile3 <- args[19]
outfile4 <- args[20]

# Load
# Top100
top100_plsda1 <- read_xlsx(infile1, sheet="top100gene")$genename
top100_plsda2 <- read_xlsx(infile2, sheet="top100gene")$genename
top100_plsda3 <- read_xlsx(infile3, sheet="top100gene")$genename
top100_plsda4 <- read_xlsx(infile4, sheet="top100gene")$genename

top100_wilcox1 <- read_xlsx(infile5, sheet="top100gene")$genename
top100_wilcox2 <- read_xlsx(infile6, sheet="top100gene")$genename
top100_wilcox3 <- read_xlsx(infile7, sheet="top100gene")$genename
top100_wilcox4 <- read_xlsx(infile8, sheet="top100gene")$genename

top100_edger1 <- read_xlsx(infile9, sheet="top100gene")$genename
top100_edger2 <- read_xlsx(infile10, sheet="top100gene")$genename
top100_edger3 <- read_xlsx(infile11, sheet="top100gene")$genename
top100_edger4 <- read_xlsx(infile12, sheet="top100gene")$genename

top100_deseq21 <- read_xlsx(infile13, sheet="top100gene")$genename
top100_deseq22 <- read_xlsx(infile14, sheet="top100gene")$genename
top100_deseq23 <- read_xlsx(infile15, sheet="top100gene")$genename
top100_deseq24 <- read_xlsx(infile16, sheet="top100gene")$genename

# Plot (Component 1)
venn.diagram(
	list(
		PLSDA=top100_plsda1,
		Wilcox=top100_wilcox1,
		edgeR=top100_edger1,
		DESeq2=top100_deseq21),
	fill=c(4,7,2,3),
	cex=2,
	cat.cex=2,
	filename = outfile1)

# Plot (Component 2)
venn.diagram(
	list(
		PLSDA=top100_plsda2,
		Wilcox=top100_wilcox2,
		edgeR=top100_edger2,
		DESeq2=top100_deseq22),
	fill=c(4,7,2,3),
	cex=2,
	cat.cex=2,
	filename = outfile2)

# Plot (Component 3)
venn.diagram(
	list(
		PLSDA=top100_plsda3,
		Wilcox=top100_wilcox3,
		edgeR=top100_edger3,
		DESeq2=top100_deseq23),
	fill=c(4,7,2,3),
	cex=2,
	cat.cex=2,
	filename = outfile3)

# Plot (Component 4)
venn.diagram(
	list(
		PLSDA=top100_plsda4,
		Wilcox=top100_wilcox4,
		edgeR=top100_edger4,
		DESeq2=top100_deseq24),
	fill=c(4,7,2,3),
	cex=2,
	cat.cex=2,
	filename = outfile4)
