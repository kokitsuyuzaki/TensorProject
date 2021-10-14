args <- commandArgs(trailingOnly = TRUE)

infile <- args[1]
outfile <- args[2]

# Input
load(infile)

# Plot
nc <- ncol(outPCA$u)
png(file=outfile, width=1000, height=1000)
pairs(outPCA$u[, seq(min(nc, 10))])
dev.off()
