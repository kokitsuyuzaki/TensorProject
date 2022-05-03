source("src/Functions.R")

# Download
td <- tempdir()
destfile <- paste0(td, "/GSE47835_RAW.tar")
download.file("https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE47835&format=file",
	destfile=destfile)
untar(destfile, exdir=td)
gsmfiles <- paste0(td, "/", c("GSM1377612_RPKM_mESC1.txt.gz", "GSM1377613_RPKM_mESC2.txt.gz", "GSM1377614_RPKM_mESC3.txt.gz", "GSM1377615_RPKM_mESC4.txt.gz", "GSM1377616_RPKM_mESC5.txt.gz", "GSM1377617_RPKM_mESC6.txt.gz", "GSM1377618_RPKM_mESC7.txt.gz", "GSM1377619_RPKM_mESC8.txt.gz", "GSM1377620_RPKM_mESC9.txt.gz", "GSM1377621_RPKM_mESC10.txt.gz", "GSM1377622_RPKM_mESC11.txt.gz", "GSM1377623_RPKM_mESC12.txt.gz", "GSM1377624_RPKM_mESC13.txt.gz", "GSM1377625_RPKM_mESC14.txt.gz", "GSM1377626_RPKM_mESC15.txt.gz", "GSM1377627_RPKM_mESC16.txt.gz", "GSM1377628_RPKM_mESC17.txt.gz", "GSM1377629_RPKM_mESC18.txt.gz", "GSM1377630_RPKM_mESC19.txt.gz", "GSM1377631_RPKM_mESC20.txt.gz", "GSM1377632_RPKM_mESC21.txt.gz", "GSM1377633_RPKM_mESC22.txt.gz", "GSM1377634_RPKM_mESC23.txt.gz", "GSM1377635_RPKM_mESC24.txt.gz", "GSM1377636_RPKM_mESC25.txt.gz", "GSM1377637_RPKM_mESC26.txt.gz", "GSM1377638_RPKM_mESC27.txt.gz", "GSM1377639_RPKM_mESC28.txt.gz", "GSM1377640_RPKM_mESC29.txt.gz", "GSM1377641_RPKM_mESC30.txt.gz", "GSM1377642_RPKM_mESC31.txt.gz", "GSM1377643_RPKM_mESC32.txt.gz", "GSM1377644_RPKM_mESC33.txt.gz", "GSM1377645_RPKM_mESC34.txt.gz", "GSM1377646_RPKM_mESC35.txt.gz", "GSM1377647_RPKM_mESC36.txt.gz", "GSM1377648_RPKM_mESC37.txt.gz", "GSM1377649_RPKM_mESC38.txt.gz", "GSM1377650_RPKM_mESC39.txt.gz", "GSM1377651_RPKM_mESC40.txt.gz", "GSM1377652_RPKM_mESC41.txt.gz", "GSM1377653_RPKM_mESC42.txt.gz", "GSM1377654_RPKM_mESC43.txt.gz", "GSM1377655_RPKM_mESC44.txt.gz", "GSM1377656_RPKM_mESC45.txt.gz", "GSM1377657_RPKM_mESC46.txt.gz", "GSM1377658_RPKM_mESC47.txt.gz", "GSM1377659_RPKM_mESC48.txt.gz", "GSM1377660_RPKM_mESC49.txt.gz", "GSM1377661_RPKM_mESC50.txt.gz", "GSM1377662_RPKM_mESC51.txt.gz", "GSM1377663_RPKM_mESC52.txt.gz", "GSM1377664_RPKM_mESC53.txt.gz", "GSM1377665_RPKM_mESC54.txt.gz", "GSM1377666_RPKM_mESC55.txt.gz", "GSM1377667_RPKM_mESC56.txt.gz", "GSM1377668_RPKM_mESC57.txt.gz", "GSM1377669_RPKM_mESC58.txt.gz", "GSM1377670_RPKM_mESC59.txt.gz", "GSM1377671_RPKM_mESC60.txt.gz", "GSM1377672_RPKM_mESC61.txt.gz", "GSM1377673_RPKM_mESC62.txt.gz", "GSM1377674_RPKM_mESC63.txt.gz", "GSM1377675_RPKM_MEF1.txt.gz", "GSM1377676_RPKM_MEF2.txt.gz", "GSM1377677_RPKM_MEF3.txt.gz", "GSM1377678_RPKM_MEF4.txt.gz", "GSM1377679_RPKM_MEF5.txt.gz", "GSM1377680_RPKM_MEF6.txt.gz", "GSM1377681_RPKM_MEF7.txt.gz", "GSM1377682_RPKM_MEF8.txt.gz"))

rpkm <- lapply(gsmfiles, read.table)
nrows <- nrow(rpkm[[1]])
rpkm <- unlist(rpkm)
dim(rpkm) <- c(nrows, length(rpkm)/nrows)

# Gene Names
genenames <- rpkm[,1]

# Label
label <- rep(c("mESC", "MEF"), c(63, 8))

# Log (RPKM + 1)
logrpkm <- matrix(0, nrow=nrow(rpkm), ncol=ncol(rpkm)/2)
logrpkm[,] <- log10(as.numeric(rpkm[, seq(2,ncol(rpkm),2)]) + 1)

# Save
write.table(logrpkm, "data/scRNAseq/Mouse_ESC_2/X_RNA.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(genenames, "data/scRNAseq/Mouse_ESC_2/GeneNames.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(label, "data/scRNAseq/Mouse_ESC_2/Label.csv",
	row.names=FALSE, col.names=FALSE, quote=FALSE)
