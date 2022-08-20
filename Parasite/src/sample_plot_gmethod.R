# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
m <- args[1]
outfile <- args[2]
infile <- paste0("output/", m, ".RData")
load(infile)

# Score
if(length(grep("guided_pls", m)) != 0){
    score_cor1 <- resgPLS$score_cor1
    score_cor2 <- resgPLS$score_cor2
}

if(m == "rbh_pls"){
    score_cor1 <- NULL
    score_cor2 <- NULL
}

if(length(grep("guided_pca", m)) != 0){
    score_cor1 <- t(resgPCA_At$u) %*% scaled_At_logTPM %*% scaled_Y_At_all
    score_cor2 <- t(resgPCA_Pj$u) %*% scaled_Pj_logTPM %*% scaled_Y_Pj_all
}

# scale
scale1 <- 10
scale2 <- 10

if(ncol(score_At) != 1){
    # Setting
    xlim <- c(min(score_At[,1], score_Pj[,1]), max(score_At[,1], score_Pj[,1]))
    ylim <- c(min(score_At[,2], score_Pj[,2]), max(score_At[,2], score_Pj[,2]))
    labels <- c(label_At, label_Pj)
    pchs <- c(rep(20, length=length(unique(label_At))),
        rep(18, length=length(unique(label_Pj))))
    # Plot
    png(file=outfile, width=900, height=700)
    par(mar = c(3,3,3,12))
    if(length(grep("guided", m)) != 0){
        plot(score_cor1[,seq(2)]/scale1, col=colorAt2, xlim=xlim, ylim=ylim,
            xlab="Component-1", ylab="Component-2",
            pch=8, cex=5, bty="n")
        par(new=TRUE)
        plot(score_cor2[,seq(2)]/scale2, col=colorPj2, xlim=xlim, ylim=ylim,
            xlab="Component-1", ylab="Component-2",
            pch=21, cex=5, bty="n")
        par(new=TRUE)
    }
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
}else{
    # Setting
    xlim <- c(min(score_At[,1], score_Pj[,1]), max(score_At[,1], score_Pj[,1]))
    labels <- c(label_At, label_Pj)
    pchs <- c(rep(20, length=length(unique(label_At))),
        rep(18, length=length(unique(label_Pj))))
    # Plot
    png(file=outfile, width=1200, height=300)
    par(mar = c(3,3,3,12))
    plot(cbind(score_cor1[,1]/scale1, 1),
        xlab="Component-1", xlim=xlim, ylim=c(1,2),
        pch=8, cex=5, bty="n", col=colorAt2[rownames(score_cor1)])
    par(new=TRUE)
    plot(cbind(score_cor2[,1]/scale2, 2),
        xlab="", xlim=xlim, ylim=c(1,2),
        pch=21, cex=5, bty="n", col=colorPj2[rownames(score_cor2)])
    par(new=TRUE)
    plot(cbind(score_At[,1], 1),
        xlab="", xlim=xlim, ylim=c(1,2),
        pch=20, cex=2, bty="n", col=label_At)
    par(new=TRUE)
    plot(cbind(score_Pj[,1], 2),
        xlab="", xlim=xlim, ylim=c(1,2),
        pch=20, cex=2, bty="n", col=label_Pj)
    dev.off()
}
