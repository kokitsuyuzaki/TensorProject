# Setting
source("src/functions.R")
load("data/objects.RData")

args <- commandArgs(trailingOnly = TRUE)
m <- args[1]
outfile <- args[2]
infile <- paste0("output/", m, ".RData")
load(infile)

if(length(grep("pca", m)) == 1){
	score_At <- score_At[,1:2] * sqrt(resgPCA_At$d[1:2])
	score_Pj <- score_Pj[,1:2] * sqrt(resgPCA_Pj$d[1:2])
	scores <- rbind(score_At, score_Pj)

	targetGeneAt <- unique(
		which(abs(cor(t(scaled_At_logTPM), score_At[,1])) >= 0.7)
		, which(abs(cor(t(scaled_At_logTPM), score_At[,1])) >= 0.7))
	backGroundAt <- setdiff(seq_len(10000), targetGeneAt)

	targetGenePj <- unique(
		which(abs(cor(t(scaled_Pj_logTPM), score_Pj[,1])) >= 0.7)
		, which(abs(cor(t(scaled_Pj_logTPM), score_Pj[,1])) >= 0.7))
	backGroundPj <- setdiff(seq_len(10000), targetGenePj)

	loadings1_1 <- resgPCA_At$u[backGroundAt, 1:2] * sqrt(resgPCA_At$d[1:2])
	loadings1_2 <- resgPCA_At$u[targetGeneAt, 1:2] * sqrt(resgPCA_At$d[1:2])
	loadings2_1 <- resgPCA_Pj$u[backGroundPj, 1:2] * sqrt(resgPCA_Pj$d[1:2])
	loadings2_2 <- resgPCA_Pj$u[targetGenePj, 1:2] * sqrt(resgPCA_Pj$d[1:2])
}
if(length(grep("pls", m)) == 1){
	score_At <- resgPLS$score1[,1:2] * sqrt(resgPLS$res$d[1:2])
	score_Pj <- resgPLS$score2[,1:2] * sqrt(resgPLS$res$d[1:2])
	scores <- rbind(score_At, score_Pj)

	targetGeneAt <- unique(
		which(abs(cor(t(scaled_At_logTPM), score_At[,1])) >= 0.7)
		, which(abs(cor(t(scaled_At_logTPM), score_At[,1])) >= 0.7))
	backGroundAt <- setdiff(seq_len(10000), targetGeneAt)

	targetGenePj <- unique(
		which(abs(cor(t(scaled_Pj_logTPM), score_Pj[,1])) >= 0.7)
		, which(abs(cor(t(scaled_Pj_logTPM), score_Pj[,1])) >= 0.7))
	backGroundPj <- setdiff(seq_len(10000), targetGenePj)

	loadings1_1 <- resgPLS$loading1[backGroundAt, 1:2] * sqrt(resgPLS$res$d[1:2])
	loadings1_2 <- resgPLS$loading1[targetGeneAt, 1:2] * sqrt(resgPLS$res$d[1:2])
	loadings2_1 <- resgPLS$loading2[backGroundPj, 1:2] * sqrt(resgPLS$res$d[1:2])
	loadings2_2 <- resgPLS$loading2[targetGenePj, 1:2] * sqrt(resgPLS$res$d[1:2])
}
if(length(grep("cca", m)) == 1){
	score_At <- resgCCA$score1[,1:2] * sqrt(resgCCA$res_svd1$d[1:2])
	score_Pj <- resgCCA$score2[,1:2] * sqrt(resgCCA$res_svd2$d[1:2])
	scores <- rbind(score_At, score_Pj)

	targetGeneAt <- unique(
		which(abs(cor(t(scaled_At_logTPM), score_At[,1])) >= 0.7)
		, which(abs(cor(t(scaled_At_logTPM), score_At[,1])) >= 0.7))
	backGroundAt <- setdiff(seq_len(10000), targetGeneAt)

	targetGenePj <- unique(
		which(abs(cor(t(scaled_Pj_logTPM), score_Pj[,1])) >= 0.7)
		, which(abs(cor(t(scaled_Pj_logTPM), score_Pj[,1])) >= 0.7))
	backGroundPj <- setdiff(seq_len(10000), targetGenePj)

	loadings1_1 <- resgCCA$loading1[backGroundAt, 1:2] * sqrt(resgCCA$res_svd1$d[1:2])
	loadings1_2 <- resgCCA$loading1[targetGeneAt, 1:2] * sqrt(resgCCA$res_svd1$d[1:2])
	loadings2_1 <- resgCCA$loading2[backGroundPj, 1:2] * sqrt(resgCCA$res_svd2$d[1:2])
	loadings2_2 <- resgCCA$loading2[targetGenePj, 1:2] * sqrt(resgCCA$res_svd2$d[1:2])
}

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
plot(loadings1_1, pch=16, cex=1,
    col=rgb(0,0,0,0.1), oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="Component-1", ylab="Component-2")
par(new=TRUE)
plot(loadings2_1, pch=16, cex=1,
    col=rgb(0,0,0,0.1), oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="", ylab="")
par(new=TRUE)
plot(loadings1_2, pch=16, cex=1,
    col=rgb(0,0,1,0.2), oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="", ylab="")
par(new=TRUE)
plot(loadings2_2, pch=16, cex=1,
    col=rgb(0,1,0,0.2), oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="", ylab="")
par(new=TRUE)
plot(scores, col=labels, xlim=xlim, ylim=ylim,
    xlab="Component-1", ylab="Component-2",
    pch=pchs, cex=3.5, bty="n")
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
