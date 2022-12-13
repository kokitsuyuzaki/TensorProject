# Setting
source("src/functions.R")
load("data/objects.RData")
load("output/pca.RData")

args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# Plot: PC5以降は個体差
png(file="plot/scatter/pca/at.png", width=900, height=700)
pairs(res_pca_At$v[, seq(4)], pch=16, cex=2,
    col=label_At, oma=c(3,3,3,25))
par(xpd = TRUE)
legend("bottomright",
    col = label_At[unique(names(label_At))],
    legend = unique(names(label_At)),
    pch = 16, cex = 1.5, bg = "transparent")
dev.off()

# Plot: PC3以降は個体差
png(file="plot/scatter/pca/pj.png", width=900, height=700)
pairs(res_pca_Pj$v[, seq(4)], pch=16, cex=2,
    col=label_Pj, oma=c(3,3,3,25), bty="n")
par(xpd = TRUE)
legend("bottomright",
    col = label_Pj[unique(names(label_Pj))],
    legend = unique(names(label_Pj)),
    pch = 16, cex = 1.5, bg = "transparent")
dev.off()

# Output
file.create(outfile)
