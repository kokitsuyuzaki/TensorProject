source("src/functions.R")

files <- c(
	paste0("output/inner_product/roc/", 2:4, "mer.RData"),
	paste0("output/euclid_distance/roc/", 2:4, "mer.RData"),
	paste0("output/delta_distance/roc/", 2:4, "mer.RData"),
	paste0("output/mahalanobis_distance/roc/", 2:4, "mer.RData"),
	paste0("output/lowrank_mahalanobis_distance/roc/", 2:4, "mer.RData"),
	paste0("output/mcd_mahalanobis_distance/roc/", 2:4, "mer.RData")
	)

auc <- c()
for(i in seq_along(files)){
	print(i)
	load(files[i])
	auc <- c(auc, out$auc)
}

method_names <- c(
	"inner product (2-mer)",
	"inner product (3-mer)",
	"inner product (4-mer)",
	"euclid distance (2-mer)",
	"euclid distance (3-mer)",
	"euclid distance (4-mer)",
	"delta distance (2-mer)",
	"delta distance (3-mer)",
	"delta distance (4-mer)",
	"mahalanobis distance (2-mer)",
	"mahalanobis distance (3-mer)",
	"mahalanobis distance (4-mer)",
	"lowrank mahalanobis distance (2-mer)",
	"lowrank mahalanobis distance (3-mer)",
	"lowrank mahalanobis distance (4-mer)",
	"MinCovDet (2-mer)",
	"MinCovDet (3-mer)",
	"MinCovDet (4-mer)")

method_names <- factor(method_names, levels=method_names)

data <- data.frame(auc=auc, method_names=method_names)

# beesworm plot
g <- ggplot(data, aes(x=method_names, y=auc, colour=method_names))
g <- g + theme(axis.text.x = element_text(angle = 65, hjust = 1))
g <- g + geom_beeswarm(dodge.width=0.1, cex = 0.6)

ggsave(file="plot/auc.png", plot=g, width=9.0, height=4.8)
