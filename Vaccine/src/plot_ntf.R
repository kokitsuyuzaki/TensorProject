source("src/Functions.R")

CP_RANKS = 1:9
K = 10

testerror <- c()
for(i in CP_RANKS){
	for(j in seq(K)){
		infile = paste0("output/ntf/", i, "_", j, ".RData")
		load(infile)
		testerror <- c(testerror, rev(out$TestRecError)[1])
	}
}
df <- data.frame(
	Rank = rep(CP_RANKS, each=K),
	Fold = rep(seq(K), length(CP_RANKS)),
	Log10_TestRecError = log10(testerror))

# ggplot
g <- ggplot(df, aes(x=Rank, y=Log10_TestRecError, group=Rank))
g <- g + geom_boxplot()
g <- g + stat_summary(fun = median, geom = "line",
	aes(group = 1), col = "red")
g <- g + labs(x = "rank", y="log10 (Reconstruction Error)")

# Save
ggsave("plot/ntf.png", g, dpi=120, width=10, height=10)
