# Setting
source("src/functions.R")
load("data/objects.RData")
load("output/pca.RData")

# At
xlim <- c(min(res_pca_At$u[,3], res_pca_At$v[,3]),
	max(res_pca_At$u[,3], res_pca_At$v[,3])) * sqrt(res_pca_At$d[3])
ylim <- c(min(res_pca_At$u[,4], res_pca_At$v[,4]),
	max(res_pca_At$u[,4], res_pca_At$v[,4])) * sqrt(res_pca_At$d[3])
pchs <- rep(20, length=length(unique(label_At)))

targetGene <- unique(
	which(abs(cor(t(scaled_At_logTPM), res_pca_At$v[,3])) >= 0.7)
	, which(abs(cor(t(scaled_At_logTPM), res_pca_At$v[,4])) >= 0.7))
backGround <- setdiff(seq_len(10000), targetGene)
loadings1 <- res_pca_At$u[backGround, 3:4] * sqrt(res_pca_At$d[3:4])
loadings2 <- res_pca_At$u[targetGene, 3:4] * sqrt(res_pca_At$d[3:4])
scores <- res_pca_At$v[, 3:4] * sqrt(res_pca_At$d[3:4])

png(file="plot/biplot_pca_at.png", width=900, height=700)
par(mar = c(3,3,3,12))
plot(loadings1, pch=16, cex=1,
    col=rgb(0,0,0,0.1), oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="Component-1", ylab="Component-2")
par(new=TRUE)
plot(loadings2, pch=16, cex=1,
    col=rgb(0,0,1,0.2), oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="", ylab="")
par(new=TRUE)
plot(scores, pch=16, cex=2,
    col=label_At, oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="", ylab="")
par(xpd = TRUE)
legend(par()$usr[2], par()$usr[4],
    col = label_At[unique(names(label_At))],
    legend = unique(names(label_At)),
    pch = pchs, cex = 1.5, bg = "transparent")
segments(xlim[1], 0, 0, 0, lty=2)
segments(xlim[2], 0, 0, 0, lty=2)
segments(0, ylim[1], 0, 0, lty=2)
segments(0, ylim[2], 0, 0, lty=2)
dev.off()

# Pj
xlim <- c(min(res_pca_Pj$u[,1], res_pca_Pj$v[,1]),
	max(res_pca_Pj$u[,1], res_pca_Pj$v[,1])) * sqrt(res_pca_Pj$d[1])
ylim <- c(min(res_pca_Pj$u[,2], res_pca_Pj$v[,2]),
	max(res_pca_Pj$u[,2], res_pca_Pj$v[,2])) * sqrt(res_pca_Pj$d[2])
pchs <- rep(18, length=length(unique(label_Pj)))

targetGene <- unique(
	which(abs(cor(t(scaled_Pj_logTPM), res_pca_Pj$v[,1])) >= 0.7)
	, which(abs(cor(t(scaled_Pj_logTPM), res_pca_Pj$v[,2])) >= 0.7))
backGround <- setdiff(seq_len(10000), targetGene)
loadings1 <- res_pca_Pj$u[backGround, 1:2] * sqrt(res_pca_Pj$d[1:2])
loadings2 <- res_pca_Pj$u[targetGene, 1:2] * sqrt(res_pca_Pj$d[1:2])
scores <- res_pca_Pj$v[, 1:2] * sqrt(res_pca_Pj$d[1:2])

png(file="plot/biplot_pca_pj.png", width=900, height=700)
par(mar = c(3,3,3,12))
plot(loadings1, pch=16, cex=1,
    col=rgb(0,0,0,0.1), oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="Component-1", ylab="Component-2")
par(new=TRUE)
plot(loadings2, pch=16, cex=1,
    col=rgb(0,0,1,0.2), oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="", ylab="")
par(new=TRUE)
plot(scores, pch=16, cex=2,
    col=label_Pj, oma=c(3,3,3,25), xlim=xlim, ylim=ylim,
    xlab="", ylab="")
par(xpd = TRUE)
legend(par()$usr[2], par()$usr[4],
    col = label_At[unique(names(label_At))],
    legend = unique(names(label_At)),
    pch = pchs, cex = 1.5, bg = "transparent")
segments(xlim[1], 0, 0, 0, lty=2)
segments(xlim[2], 0, 0, 0, lty=2)
segments(0, ylim[1], 0, 0, lty=2)
segments(0, ylim[2], 0, 0, lty=2)
dev.off()
