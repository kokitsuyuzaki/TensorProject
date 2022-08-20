# Setting
source("src/functions.R")
load("data/objects.RData")

qc_metric <- as.numeric(commandArgs(trailingOnly = TRUE)[1])
outfile <- commandArgs(trailingOnly = TRUE)[2]

# Plot
colorvec <- smoothPalette(-as.numeric(scores[, qc_metric]), pal="RdBu")

png(file=outfile, width=1000, height=1000)
pairs(res_pca_At$v[, seq(10)], col=colorvec, pch=16, cex=2,
    main=colnames(scores)[qc_metric+1])
dev.off()
