source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]
day <- as.numeric(commandArgs(trailingOnly=TRUE)[3])

# Load
load(infile)

# Preprocess
mat <- X@data[,day,]
rownames(mat) <- dimnames(X@data)$S
colnames(mat) <- dimnames(X@data)$N
tbl <- as_tibble(mat, rownames="id")
tbl <- pivot_longer(tbl, cols=as.character(seq(1516)))
colnames(tbl) <- c("Symptom", "Patient", "value")
df <- as.data.frame(tbl)
df$Symptom <- factor(df$Symptom, levels=rev(unique(df$Symptom)))
df$Patient <- factor(df$Patient, levels=seq(1516))

# ggplot
g <- ggplot(df, aes(x=Patient, y=Symptom))
g <- g + geom_tile(aes(fill=value), color="white", size=0.1)
g <- g + scale_fill_viridis(name="Score",
	limits=c(min(df$value), max(df$value)))
g <- g + theme(strip.text = element_text(colour="blue3", face=2, size=20))
g <- g + theme(axis.title.x = element_text(size=30))
g <- g + theme(axis.title.y = element_text(size=30))
g <- g + theme(legend.title = element_text(size=30))
g <- g + theme(axis.text.x = element_blank())
g <- g + ggtitle(paste("Day", dimnames(X@data)$T[day]))

# Save
ggsave(outfile, g, dpi=300, width=17, height=5)
