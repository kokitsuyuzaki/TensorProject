args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

png(file=outfile, width=960, height=480)
layout(t(1:2))
plot(as.numeric(unlist(label[3, ])), pch=16, cex=3,
	col=col.group, main="Group", xlab="Animal", ylab="PI")
plot(as.numeric(unlist(label[3, ])), pch=16, cex=3,
	col=col.pi, main="PI", xlab="Animal", ylab="PI")
dev.off()
