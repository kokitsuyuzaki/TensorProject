args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# Plot
for(i in seq_len(ncol(res.plssvd$loadingX))){
    filename <- paste0("plot/plssvd/", i, ".png")
    png(filename, width=1500, height=750)
    barplot(res.plssvd$loadingX[,i], ylim=c(-0.05, 0.05),
        main=paste("Component", i), cex.main=3)
    dev.off()
}

file.create(outfile, showWarnings=FALSE)