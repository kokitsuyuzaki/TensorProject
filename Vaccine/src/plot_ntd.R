source("src/Functions.R")

TUCKER_RANKS_1 = 1:9
TUCKER_RANKS_2 = 1:9
TUCKER_RANKS_3 = 1:9
K = 10

tmp_testerror <- c()
testerror <- c()
for(i in TUCKER_RANKS_1){
	for(j in TUCKER_RANKS_2){
		for(k in TUCKER_RANKS_3){
			for(l in seq(K)){
				infile = paste0("output/ntd/", i, "_", j, "_", k, "_", l, ".RData")
				load(infile)
				tmp_testerror <- c(tmp_testerror, rev(out$TestRecError)[1])
			}
			testerror <- c(testerror, mean(tmp_testerror))
			tmp_testerror <- c()
		}
	}
}

df <- data.frame(
	expand.grid(TUCKER_RANKS_3, TUCKER_RANKS_2, TUCKER_RANKS_1)[,3:1],
	Log10_TestRecError = log10(testerror))
colnames(df) <- c("Rank1", "Rank2", "Rank3", "Log10_TestRecError")
df$Log10_TestRecError <- round(df$Log10_TestRecError, 4)

# ggplot
g <- ggplot(df, aes(x=Rank1, y=Rank2))
g <- g + geom_tile(aes(fill=Log10_TestRecError), color="white", size=0.1)
g <- g + geom_text(aes(label=Log10_TestRecError))
g <- g + facet_wrap(~Rank3, ncol=3, scales="free")
g <- g + scale_fill_viridis(name="log10 (Reconstruction Error)",
	limits=c(min(df$Log10_TestRecError), max(df$Log10_TestRecError)))
g <- g + theme(strip.text = element_text(colour="blue3", face=2, size=20))

# Save
ggsave("plot/ntd.png", g, dpi=120, width=17, height=12)
