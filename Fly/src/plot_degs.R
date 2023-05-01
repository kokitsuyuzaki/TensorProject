source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

# Plot
for(i in seq_along(deg.genes)){
	plotfile <- paste0("plot/degs/", deg.genes[i], ".png")
	png(file=plotfile, width=960, height=480)
	layout(t(1:2))
	plot(logcount[deg.genes[i], ],
		as.numeric(unlist(label[3, ])),
		pch=16, cex=2, col=col.group,
		main="Group", xlab="Log10(Exp.+1)", ylab="PI")
	plot(logcount[deg.genes[i], ],
		as.numeric(unlist(label[3, ])),
		pch=16, cex=2, col=col.pi,
		main="PI", xlab="Log10(Exp.+1)", ylab="PI")
	dev.off()
}

file.create(outfile, showWarnings=FALSE)
