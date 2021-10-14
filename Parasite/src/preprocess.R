source("src/functions.R")

# TPM
At_TPM <- read.csv("data/naist/filtered_At_tpm.csv", header=TRUE, row.names=1)
Pj_TPM <- read.csv("data/naist/filtered_Pj_tpm.csv", header=TRUE, row.names=1)

# Log conversion
At_logTPM <- log10(as.matrix(At_TPM) + 1)
Pj_logTPM <- log10(as.matrix(Pj_TPM) + 1)

targetAt <- which(rank(1/apply(At_logTPM, 1, var)) <= 10000)
targetPj <- which(rank(1/apply(Pj_logTPM, 1, var)) <= 10000)

At_TPM <- At_TPM[targetAt, ]
Pj_TPM <- Pj_TPM[targetPj, ]
At_logTPM <- At_logTPM[targetAt, ]
Pj_logTPM <- Pj_logTPM[targetPj, ]

# Centering
scaled_At_logTPM <- t(scale(t(At_logTPM), center=TRUE, scale=FALSE))
scaled_Pj_logTPM <- t(scale(t(Pj_logTPM), center=TRUE, scale=FALSE))

# Gene Ontology
At_GO <- read.delim("data/naist/At_GO.list", header=FALSE, sep="\t")
Pj_GO <- read.delim("data/naist/Pj_GO.list", header=FALSE, sep="\t")

# Arabidopsis thaliana (wild type), root (1d,3d,7d)
At_wt_root_1d <- At_logTPM[,
    c("Col.1d.1.1", "Col.1d.2.1", "Col.1d.3.1")]
At_wt_root_3d <- At_logTPM[,
    c("Col.3d.1.1", "Col.3d.2.1", "Col.3d.3.1")]
At_wt_root_7d <- At_logTPM[,
    c("Col.7d.1.1", "Col.7d.2.1", "Col.7d.3.1")]

# Arabidopsis thaliana (wol mutant), root (1d,3d,7d)
At_wol_root_1d <- At_logTPM[,
    c("wol.1d.1.1", "wol.1d.2.1", "wol.1d.3.1")]
At_wol_root_3d <- At_logTPM[,
    c("wol.3d.1.1", "wol.3d.2.1", "wol.3d.3.1")]
At_wol_root_7d <- At_logTPM[,
    c("wol.7d.1.1", "wol.7d.2.1", "wol.7d.3.1", "wol.7d.4.1")]

# Arabidopsis thaliana (wild type)
# parasitized by Phtheirospermum japonicum,
# root (1d,3d,7d)
At_wt_1d <- At_logTPM[,
    c("Pj.Col.1d.1.1", "Pj.Col.1d.2.1",
        "Pj.Col.1d.3.1", "Pj.Col.1d.4.1")]
At_wt_3d <- At_logTPM[,
    c("Pj.Col.3d.1.1", "Pj.Col.3d.2.1",
        "Pj.Col.3d.3.1", "Pj.Col.3d.4.1")]
At_wt_7d <- At_logTPM[,
    c("Pj.Col.7d.1.1", "Pj.Col.7d.2.1", "Pj.Col.7d.3.1")]

# Arabidopsis thaliana (wol mutant)
# parasitized by Phtheirospermum japonicum,
# root (1d,3d,7d)
At_wol_1d <- At_logTPM[,
    c("Pj.wol.1d.1.1", "Pj.wol.1d.2.1",
        "Pj.wol.1d.3.1", "Pj.wol.1d.4.1")]
At_wol_3d <- At_logTPM[,
    c("Pj.wol.3d.1.1", "Pj.wol.3d.2.1",
        "Pj.wol.3d.3.1", "Pj.wol.3d.4.1", "Pj.wol.3d.5.1")]
At_wol_7d <- At_logTPM[,
    c("Pj.wol.7d.1.1", "Pj.wol.7d.2.1", "Pj.wol.7d.3.1",
        "Pj.wol.7d.4.1", "Pj.wol.7d.5.1", "Pj.wol.7d.6.1")]

# Phtheirospermum japonicum (wild type), root (1d,3d,7d)
Pj_root_1d <- Pj_logTPM[,
    c("Pj.1d.1.1", "Pj.1d.2.1", "Pj.1d.3.1", "Pj.1d.4.1")]
Pj_root_3d <- Pj_logTPM[,
    c("Pj.3d.1.1", "Pj.3d.2.1", "Pj.3d.3.1", "Pj.3d.4.1")]
Pj_root_7d <- Pj_logTPM[,
    c("Pj.7d.1.1", "Pj.7d.2.1", "Pj.7d.3.1", "Pj.7d.4.1")]

# Phtheirospermum japonicum
# parasitizing Arabidopsis thaliana (wild type)
Pj_wt_1d <- Pj_logTPM[,
    c("Pj.Col.1d.1.1", "Pj.Col.1d.2.1",
        "Pj.Col.1d.3.1", "Pj.Col.1d.4.1")]
Pj_wt_3d <- Pj_logTPM[,
    c("Pj.Col.3d.1.1", "Pj.Col.3d.2.1",
        "Pj.Col.3d.3.1", "Pj.Col.3d.4.1")]
Pj_wt_7d <- Pj_logTPM[,
    c("Pj.Col.7d.1.1", "Pj.Col.7d.2.1",
        "Pj.Col.7d.3.1", "Pj.wol.1d.1.1")]

# Phtheirospermum japonicum
# parasitizing Arabidopsis thaliana (wol mutant)
Pj_wol_1d <- Pj_logTPM[,
    c("Pj.wol.1d.2.1", "Pj.wol.1d.3.1",
        "Pj.wol.1d.4.1", "Pj.wol.3d.1.1")]
Pj_wol_3d <- Pj_logTPM[,
    c("Pj.wol.3d.2.1", "Pj.wol.3d.3.1",
        "Pj.wol.3d.4.1", "Pj.wol.3d.5.1")]
Pj_wol_7d <- Pj_logTPM[,
    c("Pj.wol.7d.1.1", "Pj.wol.7d.2.1",
        "Pj.wol.7d.3.1", "Pj.wol.7d.4.1",
        "Pj.wol.7d.5.1", "Pj.wol.7d.6.1")]

####################################
# Setting for guided PCA
####################################
# Indicator Matrix for At
Y_At_time <- matrix(0, nrow=ncol(At_logTPM), ncol=3)
Y_At_wol <- matrix(0, nrow=ncol(At_logTPM), ncol=2)
Y_At_parasm <- matrix(0, nrow=ncol(At_logTPM), ncol=2)

rownames(Y_At_time) <- colnames(At_logTPM)
rownames(Y_At_wol) <- colnames(At_logTPM)
rownames(Y_At_parasm) <- colnames(At_logTPM)

colnames(Y_At_time) <- c("1d", "3d", "7d")
colnames(Y_At_wol) <- c("wt", "wol")
colnames(Y_At_parasm) <- c("wPj", "woPj")

Y_At_time[grep("1d", rownames(Y_At_time)), 1] <- 1
Y_At_time[grep("3d", rownames(Y_At_time)), 2] <- 1
Y_At_time[grep("7d", rownames(Y_At_time)), 3] <- 1

targewol <- grep("wol", rownames(Y_At_wol))
Y_At_wol[targewol, 1] <- 1
Y_At_wol[setdiff(seq(nrow(Y_At_wol)), targewol), 2] <- 1

targetPj <- grep("^Pj", rownames(Y_At_parasm))
Y_At_parasm[targetPj, 1] <- 1
Y_At_parasm[setdiff(seq(nrow(Y_At_parasm)), targetPj), 2] <- 1

# Indicator Matrix for Pj
Y_Pj_time <- matrix(0, nrow=ncol(Pj_logTPM), ncol=3)
Y_Pj_wol <- matrix(0, nrow=ncol(Pj_logTPM), ncol=2)
Y_Pj_parasm <- matrix(0, nrow=ncol(Pj_logTPM), ncol=2)

rownames(Y_Pj_time) <- colnames(Pj_logTPM)
rownames(Y_Pj_wol) <- colnames(Pj_logTPM)
rownames(Y_Pj_parasm) <- colnames(Pj_logTPM)

colnames(Y_Pj_time) <- c("1d", "3d", "7d")
colnames(Y_Pj_wol) <- c("wt", "wol")
colnames(Y_Pj_parasm) <- c("wAt", "woAt")

Y_Pj_time[grep("1d", rownames(Y_Pj_time)), 1] <- 1
Y_Pj_time[grep("3d", rownames(Y_Pj_time)), 2] <- 1
Y_Pj_time[grep("7d", rownames(Y_Pj_time)), 3] <- 1

targewol <- grep("wol", rownames(Y_Pj_wol))
Y_Pj_wol[targewol, 1] <- 1
Y_Pj_wol[setdiff(seq(nrow(Y_Pj_wol)), targewol), 2] <- 1

Y_Pj_parasm[1:12, 2] <- 1
Y_Pj_parasm[13:38, 1] <- 1

####################################
# Setting for Plot
####################################
# label
label_At <- rep(0, length=ncol(At_TPM))

names(label_At) <- c(
    # wt root
    rep("At_wt_root_1d", 3),
    rep("At_wt_root_3d", 3),
    rep("At_wt_root_7d", 3),
    # wt parasitized by Phtheirospermum japonicum
    rep("At_wt_1d", 4),
    rep("At_wt_3d", 4),
    rep("At_wt_7d", 3),
    # wol parasitized by Phtheirospermum japonicum
    rep("At_wol_1d", 4),
    rep("At_wol_3d", 5),
    rep("At_wol_7d", 6),
    # wol root
    rep("At_wol_root_1d", 3),
    rep("At_wol_root_3d", 3),
    rep("At_wol_root_7d", 4)
    )

label_At[which(names(label_At) == "At_wt_root_1d")] <-
    colorAt["At_wt_root_1d"]
label_At[which(names(label_At) == "At_wt_root_3d")] <-
    colorAt["At_wt_root_3d"]
label_At[which(names(label_At) == "At_wt_root_7d")] <-
    colorAt["At_wt_root_7d"]

label_At[which(names(label_At) == "At_wt_1d")] <-
    colorAt["At_wt_1d"]
label_At[which(names(label_At) == "At_wt_3d")] <-
    colorAt["At_wt_3d"]
label_At[which(names(label_At) == "At_wt_7d")] <-
    colorAt["At_wt_7d"]

label_At[which(names(label_At) == "At_wol_1d")] <-
    colorAt["At_wol_1d"]
label_At[which(names(label_At) == "At_wol_3d")] <-
    colorAt["At_wol_3d"]
label_At[which(names(label_At) == "At_wol_7d")] <-
    colorAt["At_wol_7d"]

label_At[which(names(label_At) == "At_wol_root_1d")] <-
    colorAt["At_wol_root_1d"]
label_At[which(names(label_At) == "At_wol_root_3d")] <-
    colorAt["At_wol_root_3d"]
label_At[which(names(label_At) == "At_wol_root_7d")] <-
    colorAt["At_wol_root_7d"]


# label
label_Pj <- rep(0, length=ncol(Pj_TPM))

names(label_Pj) <- c(
    # wt root
    rep("Pj_root_1d", 4),
    rep("Pj_root_3d", 4),
    rep("Pj_root_7d", 4),
    # wt parasitizing At
    rep("Pj_wt_1d", 4),
    rep("Pj_wt_3d", 4),
    rep("Pj_wt_7d", 3),
    # wol parasitizing At
    rep("Pj_wol_1d", 4),
    rep("Pj_wol_3d", 5),
    rep("Pj_wol_7d", 6))

label_Pj[which(names(label_Pj) == "Pj_root_1d")] <-
    colorPj["Pj_root_1d"]
label_Pj[which(names(label_Pj) == "Pj_root_3d")] <-
    colorPj["Pj_root_3d"]
label_Pj[which(names(label_Pj) == "Pj_root_7d")] <-
    colorPj["Pj_root_7d"]

label_Pj[which(names(label_Pj) == "Pj_wt_1d")] <-
    colorPj["Pj_wt_1d"]
label_Pj[which(names(label_Pj) == "Pj_wt_3d")] <-
    colorPj["Pj_wt_3d"]
label_Pj[which(names(label_Pj) == "Pj_wt_7d")] <-
    colorPj["Pj_wt_7d"]

label_Pj[which(names(label_Pj) == "Pj_wol_1d")] <-
    colorPj["Pj_wol_1d"]
label_Pj[which(names(label_Pj) == "Pj_wol_3d")] <-
    colorPj["Pj_wol_3d"]
label_Pj[which(names(label_Pj) == "Pj_wol_7d")] <-
    colorPj["Pj_wol_7d"]

# Output
save(
    # Raw Data
    At_TPM, Pj_TPM, At_logTPM, Pj_logTPM,
    scaled_At_logTPM, scaled_Pj_logTPM,
    At_GO, Pj_GO,
    # At
    At_wt_root_1d, At_wt_root_3d, At_wt_root_7d,
    At_wol_root_1d, At_wol_root_3d, At_wol_root_7d,
    At_wt_1d, At_wt_3d, At_wt_7d,
    At_wol_1d, At_wol_3d, At_wol_7d,
    # Pj
    Pj_root_1d, Pj_root_3d, Pj_root_7d,
    Pj_wt_1d, Pj_wt_3d, Pj_wt_7d,
    Pj_wol_1d, Pj_wol_3d, Pj_wol_7d,
    # for gPCA
    Y_At_time, Y_At_wol, Y_At_parasm,
    Y_Pj_time, Y_Pj_wol, Y_Pj_parasm,
    # label
    label_At, label_Pj,
    file="data/objects.RData")
