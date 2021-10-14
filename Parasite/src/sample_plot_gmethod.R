# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
m <- args[1]
outfile <- args[2]
infile <- paste0("output/", m, ".RData")
load(infile)

xlim <- c(min(score_At[,1], score_Pj[,1]),
    max(score_At[,1], score_Pj[,1]))
ylim <- c(min(score_At[,2], score_Pj[,2]),
    max(score_At[,2], score_Pj[,2]))
labels <- c(label_At, label_Pj)
pchs <- c(rep(20, length=length(unique(label_At))),
    rep(18, length=length(unique(label_Pj))))

# Plot
png(file=outfile, width=900, height=700)
par(mar = c(3,3,3,12))
plot(score_At[,seq(2)], col=label_At, xlim=xlim, ylim=ylim,
    xlab="Component-1", ylab="Component-2",
    pch=20, cex=3.5, bty="n")
par(new=TRUE)
plot(score_Pj[,seq(2)], col=label_Pj, xlim=xlim, ylim=ylim,
    pch=18, cex=3.5, bty="n", ann=FALSE)
par(xpd = TRUE)
legend(par()$usr[2], par()$usr[4],
    col = labels[unique(names(labels))],
    legend = unique(names(labels)),
    pch = pchs, cex = 1.5, bg = "transparent")
segments(xlim[1], 0, 0, 0, lty=2)
segments(xlim[2], 0, 0, 0, lty=2)
segments(0, ylim[1], 0, 0, lty=2)
segments(0, ylim[2], 0, 0, lty=2)
dev.off()

