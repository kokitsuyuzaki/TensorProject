source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
infile4 <- args[4]
infile5 <- args[5]
infile6 <- args[6]
outfile <- args[7]

# Load
load(infile1)
load(infile2)
deg_plsda1 <- read_xlsx(infile3, sheet="deg")$genename
deg_plsda2 <- read_xlsx(infile4, sheet="deg")$genename
deg_plsda3 <- read_xlsx(infile5, sheet="deg")$genename
deg_plsda4 <- read_xlsx(infile6, sheet="deg")$genename

# Plot
for(i in seq_len(ncol(res.plssvd$loadingX))){
    filename <- paste0("plot/plssvd/", i, ".png")
    png(filename, width=1500, height=750)
    barplot(res.plssvd$loadingX[,i], ylim=c(-0.05, 0.05),
        main=paste("Component", i), cex.main=3)
    dev.off()
}

# Plot（Component 1）
dir.create("plot/plssvd/component1")
for(i in seq_along(deg_plsda1)){
    plotfile <- paste0("plot/plssvd/component1/",
        deg_plsda1[i], ".png")
    png(file=plotfile, width=960, height=480)
    layout(t(1:2))
    plot(logcount[deg_plsda1[i], ],
        as.numeric(unlist(label[3, ])),
        pch=16, cex=2, col=col.group,
        main="Group", xlab="Log10(Exp.+1)", ylab="PI")
    plot(logcount[deg_plsda1[i], ],
        as.numeric(unlist(label[3, ])),
        pch=16, cex=2, col=col.pi,
        main="PI", xlab="Log10(Exp.+1)", ylab="PI")
    dev.off()
}

# Plot（Component 2）
dir.create("plot/plssvd/component2")
for(i in seq_along(deg_plsda2)){
    plotfile <- paste0("plot/plssvd/component2/",
        deg_plsda2[i], ".png")
    png(file=plotfile, width=960, height=480)
    layout(t(1:2))
    plot(logcount[deg_plsda2[i], ],
        as.numeric(unlist(label[3, ])),
        pch=16, cex=2, col=col.group,
        main="Group", xlab="Log10(Exp.+1)", ylab="PI")
    plot(logcount[deg_plsda2[i], ],
        as.numeric(unlist(label[3, ])),
        pch=16, cex=2, col=col.pi,
        main="PI", xlab="Log10(Exp.+1)", ylab="PI")
    dev.off()
}

# Plot（Component 3）
dir.create("plot/plssvd/component3")
for(i in seq_along(deg_plsda3)){
    plotfile <- paste0("plot/plssvd/component3/",
        deg_plsda3[i], ".png")
    png(file=plotfile, width=960, height=480)
    layout(t(1:2))
    plot(logcount[deg_plsda3[i], ],
        as.numeric(unlist(label[3, ])),
        pch=16, cex=2, col=col.group,
        main="Group", xlab="Log10(Exp.+1)", ylab="PI")
    plot(logcount[deg_plsda3[i], ],
        as.numeric(unlist(label[3, ])),
        pch=16, cex=2, col=col.pi,
        main="PI", xlab="Log10(Exp.+1)", ylab="PI")
    dev.off()
}

# Plot（Component 4）
dir.create("plot/plssvd/component4")
for(i in seq_along(deg_plsda4)){
    plotfile <- paste0("plot/plssvd/component4/",
        deg_plsda4[i], ".png")
    png(file=plotfile, width=960, height=480)
    layout(t(1:2))
    plot(logcount[deg_plsda4[i], ],
        as.numeric(unlist(label[3, ])),
        pch=16, cex=2, col=col.group,
        main="Group", xlab="Log10(Exp.+1)", ylab="PI")
    plot(logcount[deg_plsda4[i], ],
        as.numeric(unlist(label[3, ])),
        pch=16, cex=2, col=col.pi,
        main="PI", xlab="Log10(Exp.+1)", ylab="PI")
    dev.off()
}

file.create(outfile, showWarnings=FALSE)