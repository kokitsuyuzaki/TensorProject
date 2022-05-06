source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Load
load(infile)

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
