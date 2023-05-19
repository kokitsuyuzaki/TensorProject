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

outfile <- args[17]

# Load
# DEG
no_deg_plsda1 <- nrow(read_xlsx(infile1, sheet="deg"))
no_deg_plsda2 <- nrow(read_xlsx(infile2, sheet="deg"))
no_deg_plsda3 <- nrow(read_xlsx(infile3, sheet="deg"))
no_deg_plsda4 <- nrow(read_xlsx(infile4, sheet="deg"))

no_deg_wilcox1 <- nrow(read_xlsx(infile5, sheet="deg"))
no_deg_wilcox2 <- nrow(read_xlsx(infile6, sheet="deg"))
no_deg_wilcox3 <- nrow(read_xlsx(infile7, sheet="deg"))
no_deg_wilcox4 <- nrow(read_xlsx(infile8, sheet="deg"))

no_deg_edger1 <- nrow(read_xlsx(infile9, sheet="deg"))
no_deg_edger2 <- nrow(read_xlsx(infile10, sheet="deg"))
no_deg_edger3 <- nrow(read_xlsx(infile11, sheet="deg"))
no_deg_edger4 <- nrow(read_xlsx(infile12, sheet="deg"))

no_deg_deseq21 <- nrow(read_xlsx(infile13, sheet="deg"))
no_deg_deseq22 <- nrow(read_xlsx(infile14, sheet="deg"))
no_deg_deseq23 <- nrow(read_xlsx(infile15, sheet="deg"))
no_deg_deseq24 <- nrow(read_xlsx(infile16, sheet="deg"))

no_deg <- c(no_deg_plsda1,no_deg_plsda2,no_deg_plsda3,no_deg_plsda4,
no_deg_wilcox1,no_deg_wilcox2,no_deg_wilcox3,no_deg_wilcox4,
no_deg_edger1,no_deg_edger2,no_deg_edger3,no_deg_edger4,
no_deg_deseq21,no_deg_deseq22,no_deg_deseq23,no_deg_deseq24)

no_deg <- log10(no_deg + 1)

method <- factor(c(rep("PLS-DA", 4), rep("Wilcoxon", 4), rep("edgeR", 4), rep("DESeq2", 4)), levels=c("PLS-DA", "Wilcoxon", "edgeR", "DESeq2"))

component <- factor(rep(1:4, 4))

# Plot
# method, component, no_degの順
deg <- data.frame(
	method=method,
	component=component,
	no_deg=no_deg)

g <- ggplot(deg, aes(x=component, y=no_deg, fill=method))
g <- g + geom_bar(stat="identity", position="dodge")
g <- g + xlab("Component")
g <- g + ylab("Log10(# DEG + 1)")

ggsave(file=outfile, plot=g, width=15, height=12)
