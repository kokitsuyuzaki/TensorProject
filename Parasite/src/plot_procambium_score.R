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

# Procambium Genes
geneid_at_1 <- procambium_At[seq(50), "GENEID"]
target_at_1 <- unlist(sapply(geneid_at_1, function(x){
	which(rownames(scaled_At_logTPM) == x)
}))
gdata_at_1 <- scaled_At_logTPM[target_at_1, ]

# GO
geneid_at_2 <- unique(At_GO_BP[which(At_GO_BP$GOID == "GO:0010067"), "GENEID"])
target_at_2 <- unlist(sapply(geneid_at_2, function(x){
	which(rownames(scaled_At_logTPM) == x)
}))
gdata_at_2 <- scaled_At_logTPM[target_at_2, ]

# GENEID => Symbol
for(i in seq(nrow(gdata_at_1))){
	target <- which(rownames(gdata_at_1)[i] == procambium_At$GENEID)
	if(length(target) != 0){
		rownames(gdata_at_1)[i] <- procambium_At[target, "SYMBOL"]
	}
}

for(i in seq(nrow(gdata_at_2))){
	target <- which(rownames(gdata_at_2)[i] == procambium_At$GENEID)
	if(length(target) != 0){
		rownames(gdata_at_2)[i] <- procambium_At[target, "SYMBOL"]
	}
}

# Preprocess
samplename <- colnames(gdata_at_1)
gdata_at_1 <- melt(gdata_at_1)
gdata_at_2 <- melt(gdata_at_2)
rownames(score_At) <- samplename
gdata_at_3 <- melt(t(score_At))
gdata_at_4 <- melt(t(Y_At_all))
colnames(gdata_at_1)[3] <- "GeneExp."
colnames(gdata_at_2)[3] <- "GeneExp."
colnames(gdata_at_3)[3] <- "Score"
colnames(gdata_at_4)[3] <- "MetaData"

# Plot
g_at_1 <- ggplot(gdata_at_1, aes(x=Var2, y=Var1, fill=GeneExp.))
g_at_1 <- g_at_1 + geom_tile()
g_at_1 <- g_at_1 + scale_fill_viridis()
g_at_1 <- g_at_1 + theme(text = element_text(size=24))
g_at_1 <- g_at_1 + theme(axis.title.x = element_blank())
g_at_1 <- g_at_1 + theme(axis.text.x = element_blank())
g_at_1 <- g_at_1 + theme(axis.title.y = element_blank())
g_at_1 <- g_at_1 + theme(legend.position = "none")

g_at_2 <- ggplot(gdata_at_2, aes(x=Var2, y=Var1, fill=GeneExp.))
g_at_2 <- g_at_2 + geom_tile()
g_at_2 <- g_at_2 + scale_fill_viridis()
g_at_2 <- g_at_2 + theme(text = element_text(size=24))
g_at_2 <- g_at_2 + theme(axis.title.x = element_blank())
g_at_2 <- g_at_2 + theme(axis.text.x = element_blank())
g_at_2 <- g_at_2 + theme(axis.title.y = element_blank())
g_at_2 <- g_at_2 + theme(legend.position = "none")

g_at_3 <- ggplot(gdata_at_3, aes(x=Var2, y=Var1, fill=Score))
g_at_3 <- g_at_3 + geom_tile()
g_at_3 <- g_at_3 + scale_fill_viridis()
g_at_3 <- g_at_3 + theme(text = element_text(size=24))
g_at_3 <- g_at_3 + theme(axis.title.x = element_blank())
g_at_3 <- g_at_3 + theme(axis.text.x = element_blank())
g_at_3 <- g_at_3 + theme(axis.title.y = element_blank())
g_at_3 <- g_at_3 + theme(legend.position = "none")

g_at_4 <- ggplot(gdata_at_4, aes(x=Var2, y=Var1, fill=MetaData))
g_at_4 <- g_at_4 + geom_tile()
g_at_4 <- g_at_4 + scale_fill_viridis()
g_at_4 <- g_at_4 + theme(text = element_text(size=24))
g_at_4 <- g_at_4 + theme(axis.title.x = element_blank())
g_at_4 <- g_at_4 + theme(axis.text.x = element_text(size=12, angle=90, hjust=1))
g_at_4 <- g_at_4 + theme(axis.title.y = element_blank())
g_at_4 <- g_at_4 + theme(legend.position = "none")


#
# Pj
#
colnames(score_Pj) <- paste0("Dim", seq(ncol(score_Pj)))

# Procambium Genes
geneid_pj_1 <- procambium_Pj[seq(200), "GENEID"]
target_pj_1 <- unlist(sapply(geneid_pj_1, function(x){
	which(rownames(scaled_Pj_logTPM) == x)
}))
gdata_pj_1 <- scaled_Pj_logTPM[target_pj_1, ]

# GO
geneid_pj_2 <- unique(Pj_GO_BP[which(Pj_GO_BP$GOID == "GO:0010067"), "GENEID"])
target_pj_2 <- unlist(sapply(geneid_pj_2, function(x){
	which(rownames(scaled_Pj_logTPM) == x)
}))
gdata_pj_2 <- scaled_Pj_logTPM[target_pj_2, ]

# GENEID => Symbol
for(i in seq(nrow(gdata_pj_1))){
	target <- which(rownames(gdata_pj_1)[i] == procambium_Pj$GENEID)
	if(length(target) != 0){
		rownames(gdata_pj_1)[i] <- procambium_Pj[target, "SYMBOL"]
	}
}

for(i in seq(nrow(gdata_pj_2))){
	target <- which(rownames(gdata_pj_2)[i] == procambium_Pj$GENEID)
	if(length(target) != 0){
		rownames(gdata_pj_2)[i] <- procambium_Pj[target, "SYMBOL"]
	}
}

# Preprocess
samplename <- colnames(gdata_pj_1)
gdata_pj_1 <- melt(gdata_pj_1)
gdata_pj_2 <- melt(gdata_pj_2)
rownames(score_Pj) <- samplename
gdata_pj_3 <- melt(t(score_Pj))
gdata_pj_4 <- melt(t(Y_Pj_all))
colnames(gdata_pj_1)[3] <- "GeneExp."
colnames(gdata_pj_2)[3] <- "GeneExp."
colnames(gdata_pj_3)[3] <- "Score"
colnames(gdata_pj_4)[3] <- "MetaData"

# Plot
g_pj_1 <- ggplot(gdata_pj_1, aes(x=Var2, y=Var1, fill=GeneExp.))
g_pj_1 <- g_pj_1 + geom_tile()
g_pj_1 <- g_pj_1 + scale_fill_viridis()
g_pj_1 <- g_pj_1 + theme(text = element_text(size=24))
g_pj_1 <- g_pj_1 + theme(axis.title.x = element_blank())
g_pj_1 <- g_pj_1 + theme(axis.text.x = element_blank())
g_pj_1 <- g_pj_1 + theme(axis.title.y = element_blank())
g_pj_1 <- g_pj_1 + labs(fill = "GeneExp.\n(Wendrich2020)")

g_pj_2 <- ggplot(gdata_pj_2, aes(x=Var2, y=Var1, fill=GeneExp.))
g_pj_2 <- g_pj_2 + geom_tile()
g_pj_2 <- g_pj_2 + scale_fill_viridis()
g_pj_2 <- g_pj_2 + theme(text = element_text(size=24))
g_pj_2 <- g_pj_2 + theme(axis.title.x = element_blank())
g_pj_2 <- g_pj_2 + theme(axis.text.x = element_blank())
g_pj_2 <- g_pj_2 + theme(axis.title.y = element_blank())
g_pj_2 <- g_pj_2 + labs(fill = "GeneExp.\n(GO:0010067)")

g_pj_3 <- ggplot(gdata_pj_3, aes(x=Var2, y=Var1, fill=Score))
g_pj_3 <- g_pj_3 + geom_tile()
g_pj_3 <- g_pj_3 + scale_fill_viridis()
g_pj_3 <- g_pj_3 + theme(text = element_text(size=24))
g_pj_3 <- g_pj_3 + theme(axis.title.x = element_blank())
g_pj_3 <- g_pj_3 + theme(axis.text.x = element_blank())
g_pj_3 <- g_pj_3 + theme(axis.title.y = element_blank())

g_pj_4 <- ggplot(gdata_pj_4, aes(x=Var2, y=Var1, fill=MetaData))
g_pj_4 <- g_pj_4 + geom_tile()
g_pj_4 <- g_pj_4 + scale_fill_viridis()
g_pj_4 <- g_pj_4 + theme(text = element_text(size=24))
g_pj_4 <- g_pj_4 + theme(axis.title.x = element_blank())
g_pj_4 <- g_pj_4 + theme(axis.text.x = element_text(size=12, angle=90, hjust=1))
g_pj_4 <- g_pj_4 + theme(axis.title.y = element_blank())

# Plot
g <- g_at_1 + g_pj_1 + g_at_2 + g_pj_2 + g_at_3 + g_pj_3 + g_at_4 + g_pj_4 + plot_layout(nrow=4, ncol=2, heights=c(2,1.5,1,1), widths=c(1,1))

ggsave(file=outfile, plot=g, width=20, height=16)
