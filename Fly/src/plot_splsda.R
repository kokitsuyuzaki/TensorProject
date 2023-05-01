args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile1 <- args[3]
outfile2 <- args[4]
outfile3 <- args[5]
outfile4 <- args[6]

# Load
load(infile1)
load(infile2)

# Plot
png(file=outfile1, width=960, height=960)
pairs(res.splsda$scoreX, pch=16, cex=2, col=col.group, main="Group")
dev.off()

png(file=outfile2, width=960, height=960)
pairs(res.splsda$scoreX, pch=16, cex=2, col=col.pi, main="PI")
dev.off()

png(file=outfile3, width=960, height=960)
pairs(res.splsda.deg$scoreX, pch=16, cex=2, col=col.group, main="Group")
dev.off()

png(file=outfile4, width=960, height=960)
pairs(res.splsda.deg$scoreX, pch=16, cex=2, col=col.pi, main="PI")
dev.off()
