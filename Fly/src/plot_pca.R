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
pairs(res.pca$x[,1:20], pch=16, col=col.group, main="Group")
dev.off()

png(file=outfile2, width=960, height=960)
pairs(res.pca$x[,1:20], pch=16, col=col.pi, main="PI")
dev.off()

png(file=outfile3, width=960, height=960)
pairs(res.pca.deg$x[,1:20], pch=16, col=col.group, main="Group")
dev.off()

png(file=outfile4, width=960, height=960)
pairs(res.pca.deg$x[,1:20], pch=16, col=col.pi, main="PI")
dev.off()
