source("src/functions.R")
load("data/objects.RData")

# Parameter
m <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Roading each method
infile <- paste0("output/", m, ".RData")
load(infile)

#
# At
#
colnames(score_At) <- paste0("Dim", seq(ncol(score_At)))
geneid_at <- unique(At_GO_BP[which(At_GO_BP$GOID == "GO:0010067"), "GENEID"])
target_at <- unlist(sapply(geneid_at, function(x){
	which(rownames(scaled_At_logTPM) == x)
}))
gdata_at_1 <- scaled_At_logTPM[target_at, ]

# Preprocess
samplename <- colnames(gdata_at_1)
gdata_at_1 <- melt(gdata_at_1)
rownames(score_At) <- samplename
gdata_at_2 <- melt(t(score_At))
gdata_at_3 <- melt(t(Y_At_all))
colnames(gdata_at_1)[3] <- "GeneExp."
colnames(gdata_at_2)[3] <- "Score"
colnames(gdata_at_3)[3] <- "MetaData"

# Plot
g_at_1 <- ggplot(gdata_at_1, aes(x=Var2, y=Var1, fill=GeneExp.))
g_at_1 <- g_at_1 + geom_tile()
g_at_1 <- g_at_1 + scale_fill_viridis()
g_at_1 <- g_at_1 + theme(text = element_text(size=24))
g_at_1 <- g_at_1 + theme(axis.title.x = element_blank())
g_at_1 <- g_at_1 + theme(axis.text.x = element_blank())
g_at_1 <- g_at_1 + theme(axis.title.y = element_blank())
g_at_1 <- g_at_1 + theme(legend.position = "none")

g_at_2 <- ggplot(gdata_at_2, aes(x=Var2, y=Var1, fill=Score))
g_at_2 <- g_at_2 + geom_tile()
g_at_2 <- g_at_2 + scale_fill_viridis()
g_at_2 <- g_at_2 + theme(text = element_text(size=24))
g_at_2 <- g_at_2 + theme(axis.title.x = element_blank())
g_at_2 <- g_at_2 + theme(axis.text.x = element_blank())
g_at_2 <- g_at_2 + theme(axis.title.y = element_blank())
g_at_2 <- g_at_2 + theme(legend.position = "none")

g_at_3 <- ggplot(gdata_at_3, aes(x=Var2, y=Var1, fill=MetaData))
g_at_3 <- g_at_3 + geom_tile()
g_at_3 <- g_at_3 + scale_fill_viridis()
g_at_3 <- g_at_3 + theme(text = element_text(size=24))
g_at_3 <- g_at_3 + theme(axis.title.x = element_blank())
g_at_3 <- g_at_3 + theme(axis.text.x = element_text(size=12, angle=90, hjust=1))
g_at_3 <- g_at_3 + theme(axis.title.y = element_blank())
g_at_3 <- g_at_3 + theme(legend.position = "none")

#
# Pj
#
colnames(score_Pj) <- paste0("Dim", seq(ncol(score_Pj)))
geneid_pj <- unique(Pj_GO_BP[which(Pj_GO_BP$GOID == "GO:0010067"), "GENEID"])
target_pj <- unlist(sapply(geneid_pj, function(x){
	which(rownames(scaled_Pj_logTPM) == x)
}))
gdata_pj_1 <- scaled_Pj_logTPM[target_pj, ]

# Preprocess
samplename <- colnames(gdata_pj_1)
gdata_pj_1 <- melt(gdata_pj_1)
rownames(score_Pj) <- samplename
gdata_pj_2 <- melt(t(score_Pj))
gdata_pj_3 <- melt(t(Y_Pj_all))
colnames(gdata_pj_1)[3] <- "GeneExp."
colnames(gdata_pj_2)[3] <- "Score"
colnames(gdata_pj_3)[3] <- "MetaData"

# Plot
g_pj_1 <- ggplot(gdata_pj_1, aes(x=Var2, y=Var1, fill=GeneExp.))
g_pj_1 <- g_pj_1 + geom_tile()
g_pj_1 <- g_pj_1 + scale_fill_viridis()
g_pj_1 <- g_pj_1 + theme(text = element_text(size=24))
g_pj_1 <- g_pj_1 + theme(axis.title.x = element_blank())
g_pj_1 <- g_pj_1 + theme(axis.text.x = element_blank())
g_pj_1 <- g_pj_1 + theme(axis.title.y = element_blank())

g_pj_2 <- ggplot(gdata_pj_2, aes(x=Var2, y=Var1, fill=Score))
g_pj_2 <- g_pj_2 + geom_tile()
g_pj_2 <- g_pj_2 + scale_fill_viridis()
g_pj_2 <- g_pj_2 + theme(text = element_text(size=24))
g_pj_2 <- g_pj_2 + theme(axis.title.x = element_blank())
g_pj_2 <- g_pj_2 + theme(axis.text.x = element_blank())
g_pj_2 <- g_pj_2 + theme(axis.title.y = element_blank())

g_pj_3 <- ggplot(gdata_pj_3, aes(x=Var2, y=Var1, fill=MetaData))
g_pj_3 <- g_pj_3 + geom_tile()
g_pj_3 <- g_pj_3 + scale_fill_viridis()
g_pj_3 <- g_pj_3 + theme(text = element_text(size=24))
g_pj_3 <- g_pj_3 + theme(axis.title.x = element_blank())
g_pj_3 <- g_pj_3 + theme(axis.text.x = element_text(size=12, angle=90, hjust=1))
g_pj_3 <- g_pj_3 + theme(axis.title.y = element_blank())

# Plot
g <- g_at_1 + g_pj_1 + g_at_2 + g_pj_2 + g_at_3 + g_pj_3 + plot_layout(nrow=3, ncol=2, heights=c(2,1,1), widths=c(1,1))

ggsave(file=outfile, plot=g, width=16, height=10)
