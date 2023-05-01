args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile1 <- args[3]
outfile2 <- args[4]

# Load
load(infile1)
load(infile2)

# Plot
png(file=outfile1, width=960, height=480)
layout(t(1:2))
plot(res.tsne$Y, pch=16, cex=2, col=col.group, main="Group",
	xlab="tSNE-1", ylab="tSNE-2")
plot(res.tsne$Y, pch=16, cex=2, col=col.pi, main="PI",
	xlab="tSNE-1", ylab="tSNE-2")
dev.off()

png(file=outfile2, width=960, height=480)
layout(t(1:2))
plot(res.tsne.deg$Y, pch=16, cex=2, col=col.group, main="Group",
	xlab="tSNE-1", ylab="tSNE-2")
plot(res.tsne.deg$Y, pch=16, cex=2, col=col.pi, main="PI",
	xlab="tSNE-1", ylab="tSNE-2")
dev.off()

