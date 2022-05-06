library("nnTensor")
library("rTensor")
library("ggplot2")
library("tidyr")
library("viridis")

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

aggregate_ntd <- function(TUCKER_RANKS_1, TUCKER_RANKS_2, TUCKER_RANKS_3, K){
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
				testerror <- c(testerror, median(tmp_testerror))
				tmp_testerror <- c()
			}
		}
	}
	df <- data.frame(
		expand.grid(TUCKER_RANKS_3, TUCKER_RANKS_2, TUCKER_RANKS_1)[,3:1],
		Log10_TestRecError = log10(testerror))
	colnames(df) <- c("Rank1", "Rank2", "Rank3", "Log10_TestRecError")
	df$Log10_TestRecError <- round(df$Log10_TestRecError, 4)
	df
}
