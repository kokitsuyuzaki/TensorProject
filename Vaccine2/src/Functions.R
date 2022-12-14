# Packages
library("readxl")
library("tidyverse")
library("einsum")
library("abind")
library("reticulate")
library("rTensor")
library("nnTensor")
library("ggplot2")
library("viridis")
library("stringr")

# Setting
metadata_name <- c("ID", "Sex", "AgeCategory", "BMICategory",
    "ShotSite", "ShotInterval", "IntervalToTest", "PostTiterLog2",
    "Antiinflammatory")

symptoms <- c("joint_pain",  "fatigue",  "fever",  "cold",
    "headache",  "muscle_pain",  "nausea",  "flare",
    "swelling",  "pain",  "use_painkiller",  "medical_checkup")

days <- c(paste(1, 1:7, sep="_"), paste(2, 1:7, sep="_"))

thr <- length(symptoms) * length(days) * 0.3

aggregate_ntf <- function(CP_RANKS, K){
    testerror <- c()
    for(i in CP_RANKS){
        for(j in seq(K)){
            infile = paste0("output/ntf/", i, "_", j, ".RData")
            load(infile)
            testerror <- c(testerror, rev(out$TestRecError)[1])
        }
    }
    data.frame(
        Rank = rep(CP_RANKS, each=K),
        Fold = rep(seq(K), length(CP_RANKS)),
        Log10_TestRecError = log10(testerror))
}
