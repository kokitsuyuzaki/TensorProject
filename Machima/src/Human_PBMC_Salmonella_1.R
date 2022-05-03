source("src/Functions.R")

# Download
td <- tempdir()
destfile1 <- paste0(td, "/GSM3454528_naive_cells.txt.gz")
destfile2 <- paste0(td, "/GSM3454529_Salmonella_exposed_cells.txt.gz")

download.file("https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3454nnn/GSM3454528/suppl/GSM3454528%5Fnaive%5Fcells%2Etxt%2Egz",
	destfile=destfile1)
download.file("https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3454nnn/GSM3454529/suppl/GSM3454529%5FSalmonella%5Fexposed%5Fcells%2Etxt%2Egz",
	destfile=destfile2)



counts1 <- read.table(destfile1, skip=1)
row.names1 <- counts1[,1]
counts1 <- counts1[, 2:ncol(counts1)]
col.names1 <- read.table(destfile1, nrow=1)
col.names1 <- col.names1[2:length(col.names1)]
colnames(counts1) <- col.names1

counts2 <- read.table(destfile2, skip=1)
row.names2 <- counts2[,1]
counts2 <- counts2[, 2:ncol(counts2)]
col.names2 <- read.table(destfile2, nrow=1)
col.names2 <- col.names2[2:length(col.names2)]
colnames(counts2) <- col.names2

label1 <- read.table("naive.txt")[,2]
label2 <- read.table("salmonella.txt")[,2]
names(label1) <- read.table("naive.txt")[,1]
names(label2) <- read.table("salmonella.txt")[,1]

label1 <- label1[colnames(counts1)]
label2 <- label2[colnames(counts2)]


