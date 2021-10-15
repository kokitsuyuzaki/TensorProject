source("src/functions.R")
load("data/objects.RData")

# guided-PCA
load("output/time_guided_pca.RData")
resgPCA_At_time <- resgPCA_At
resgPCA_Pj_time <- resgPCA_Pj
load("output/wol_guided_pca.RData")
resgPCA_At_wol <- resgPCA_At
resgPCA_Pj_wol <- resgPCA_Pj
load("output/parasm_guided_pca.RData")
resgPCA_At_parasm <- resgPCA_At
resgPCA_Pj_parasm <- resgPCA_Pj
load("output/pca.RData")

# All Variance
var_At <- sum(diag(var(t(scaled_At_logTPM) %*% res_pca_At$u)))
var_Pj <- sum(diag(var(t(scaled_Pj_logTPM) %*% res_pca_Pj$u)))

var_At_time <- sum(diag(var(t(scaled_At_logTPM) %*% resgPCA_At_time$u)))
var_At_wol <- sum(diag(var(t(scaled_At_logTPM) %*% resgPCA_At_wol$u)))
var_At_Pj <- sum(diag(var(t(scaled_At_logTPM) %*% resgPCA_At_parasm$u)))

var_Pj_time <- sum(diag(var(t(scaled_Pj_logTPM) %*% resgPCA_Pj_time$u)))
var_Pj_wol <- sum(diag(var(t(scaled_Pj_logTPM) %*% resgPCA_Pj_wol$u)))
var_Pj_At <- sum(diag(var(t(scaled_Pj_logTPM) %*% resgPCA_Pj_parasm$u)))

# Plot
prop_At_time <- 100 * var_At_time / var_At
prop_At_wol <- 100 * var_At_wol / var_At
prop_At_Pj <- 100 * var_At_Pj / var_At
prop_At_Residual <- 100 - prop_At_time - prop_At_wol - prop_At_Pj

prop_Pj_time <- 100 * var_Pj_time / var_Pj
prop_Pj_wol <- 100 * var_Pj_wol / var_Pj
prop_Pj_At <- 100 * var_Pj_At / var_Pj
prop_Pj_Residual <- 100 - prop_Pj_time - prop_Pj_wol - prop_Pj_At

prop_At <- data.frame(
	factor=c("time", "wol", "parasitism", "residual"),
	proportion=c(prop_At_time, prop_At_wol,
		prop_At_Pj, prop_At_Residual)
	)
prop_Pj <- data.frame(
	factor=c("time", "wol", "parasitism", "residual"),
	proportion=c(prop_Pj_time, prop_Pj_wol,
		prop_Pj_At, prop_Pj_Residual)
	)

prop_At$factor <- factor(prop_At$factor,
	levels = c("time", "wol", "parasitism", "residual"))

prop_Pj$factor <- factor(prop_Pj$factor,
	levels = c("time", "wol", "parasitism", "residual"))

g1 <- ggplot(prop_At, aes(x=factor, y=proportion, fill=factor))
g1 <- g1 + geom_bar(stat="identity")
g1 <- g1 + theme(axis.text.x = element_text(angle = 45, hjust = 1))
g1 <- g1 + xlab("Factor")
g1 <- g1 + ylab("Proportion (%)")

g2 <- ggplot(prop_Pj, aes(x=factor, y=proportion, fill=factor))
g2 <- g2 + geom_bar(stat="identity")
g2 <- g2 + theme(axis.text.x = element_text(angle = 45, hjust = 1))
g2 <- g2 + xlab("Factor")
g2 <- g2 + ylab("Proportion (%)")

ggsave(file='plot/proportion_plot_at.png', plot=g1, width=3, height=3)
ggsave(file='plot/proportion_plot_pj.png', plot=g2, width=3, height=3)
