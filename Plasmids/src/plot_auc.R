source("src/functions.R")

files <- c(
	paste0("output/euclid_distance/roc/", 2:4, "mer.RData"),
	paste0("output/sigma_distance/roc/", 2:4, "mer.RData"),
	paste0("output/mahalanobis_distance/roc/", 2:4, "mer.RData"),
	paste0("output/inner_product/roc/", 2:4, "mer.RData"),
	paste0("output/nmf_similarity/roc/2mer_", 2:16, ".RData"),
	paste0("output/nmf_similarity/roc/3mer_", 2:16, ".RData"),
	paste0("output/nmf_similarity/roc/4mer_", 2:16, ".RData"),
	paste0("output/sinmf_similarity/roc/2mer_", 2:16, ".RData"),
	paste0("output/sinmf_similarity/roc/3mer_", 2:16, ".RData"),
	paste0("output/sinmf_similarity/roc/4mer_", 2:16, ".RData"),
	paste0("output/jnmf_similarity/roc/2mer_", 2:16, ".RData"),
	paste0("output/jnmf_similarity/roc/3mer_", 2:16, ".RData"),
	paste0("output/jnmf_similarity/roc/4mer_", 2:16, ".RData"))

auc <- c()
for(i in seq_along(files)){
	print(i)
	load(files[i])
	auc <- c(auc, out$auc)
}

method_names <- c(
	"euclid distance (2-mer)",
	"euclid distance (3-mer)",
	"euclid distance (4-mer)",
	"sigma distance (2-mer)",
	"sigma distance (3-mer)",
	"sigma distance (4-mer)",
	"mahalanobis distance (2-mer)",
	"mahalanobis distance (3-mer)",
	"mahalanobis distance (4-mer)",
	"inner product (2-mer)",
	"inner product (3-mer)",
	"inner product (4-mer)",
	rep("nmf similarity (2-mer)", 15),
	rep("nmf similarity (3-mer)", 15),
	rep("nmf similarity (4-mer)", 15),
	rep("sinmf similarity (2-mer)", 15),
	rep("sinmf similarity (3-mer)", 15),
	rep("sinmf similarity (4-mer)", 15),
	rep("jnmf similarity (2-mer)", 15),
	rep("jnmf similarity (3-mer)", 15),
	rep("jnmf similarity (4-mer)", 15))

method_names <- factor(method_names,
	levels=c(
		"euclid distance (2-mer)",
		"euclid distance (3-mer)",
		"euclid distance (4-mer)",
		"sigma distance (2-mer)",
		"sigma distance (3-mer)",
		"sigma distance (4-mer)",
		"mahalanobis distance (2-mer)",
		"mahalanobis distance (3-mer)",
		"mahalanobis distance (4-mer)",
		"inner product (2-mer)",
		"inner product (3-mer)",
		"inner product (4-mer)",
		"nmf similarity (2-mer)",
		"nmf similarity (3-mer)",
		"nmf similarity (4-mer)",
		"sinmf similarity (2-mer)",
		"sinmf similarity (3-mer)",
		"sinmf similarity (4-mer)",
		"jnmf similarity (2-mer)",
		"jnmf similarity (3-mer)",
		"jnmf similarity (4-mer)"))

data <- data.frame(auc=auc, method_names=method_names)

# beesworm plot
g <- ggplot(data, aes(x=method_names, y=auc, colour=method_names))
g <- g + theme(axis.text.x = element_text(angle = 65, hjust = 1))
g <- g + geom_beeswarm(dodge.width=0.1, cex = 0.6)

ggsave(file="plot/auc.png", plot=g, width=9.0, height=4.8)
