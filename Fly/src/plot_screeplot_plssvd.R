args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# Plot
png(file=outfile, width=400, height=400)
plot(cumsum(res.plssvd$d)/sum(res.plssvd$d)*100, pch=16, cex=2,
	type="b",
	xlab="Component",
	ylab="Cumulative sum of singular values (%)",
	main="")
dev.off()
