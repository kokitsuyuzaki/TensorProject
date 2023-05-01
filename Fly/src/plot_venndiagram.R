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
outfile1 <- args[9]
outfile2 <- args[10]
outfile3 <- args[11]
outfile4 <- args[12]

# Load
deg_plsda1 <- read_xlsx(infile1, sheet="deg")$genename
deg_plsda2 <- read_xlsx(infile2, sheet="deg")$genename
deg_plsda3 <- read_xlsx(infile3, sheet="deg")$genename
deg_plsda4 <- read_xlsx(infile4, sheet="deg")$genename
deg_wilcox1 <- read_xlsx(infile5, sheet="deg")$genename
deg_wilcox2 <- read_xlsx(infile6, sheet="deg")$genename
deg_wilcox3 <- read_xlsx(infile7, sheet="deg")$genename
deg_wilcox4 <- read_xlsx(infile8, sheet="deg")$genename

# Plot (Component 1)
venn.diagram(
	list(
		PLSDA=deg_plsda1,
		Wilcox=deg_wilcox1),
	fill=c(4,7),
	cex=2,
	cat.cex=2,
	filename = outfile1)

# Plot (Component 2)
venn.diagram(
	list(
		PLSDA=deg_plsda2,
		Wilcox=deg_wilcox2),
	fill=c(4,7),
	cex=2,
	cat.cex=2,
	filename = outfile2)

# Plot (Component 3)
venn.diagram(
	list(
		PLSDA=deg_plsda3,
		Wilcox=deg_wilcox3),
	fill=c(4,7),
	cex=2,
	cat.cex=2,
	filename = outfile3)

# Plot (Component 4)
venn.diagram(
	list(
		PLSDA=deg_plsda4,
		Wilcox=deg_wilcox4),
	fill=c(4,7),
	cex=2,
	cat.cex=2,
	filename = outfile4)
