args <- commandArgs(trailingOnly = TRUE)

infile <- args[1]
outfile <- args[2]

# Input
load(infile)

# Plot
png(file=outfile, width=1000, height=1000)
plot(outtSNE$Y, xlab="tSNE-1", ylab="tSNE-2",
	pch=16, col=rgb(0,0,0,0.6))
dev.off()
