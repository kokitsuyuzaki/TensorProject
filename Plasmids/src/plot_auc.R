source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)


load('output/sigma_distance/roc/2mer.RData')
load('output/sigma_distance/roc/3mer.RData')
load('output/sigma_distance/roc/4mer.RData')

load('output/mahalanobis_distance/roc/2mer.RData')
load('output/mahalanobis_distance/roc/3mer.RData')
load('output/mahalanobis_distance/roc/4mer.RData')



'output/{previous}/roc/{wordsize}mer.RData',
	previous=PREVIOUS_METHODS, wordsize=WORDSIZE)

'output/{nmf}/roc/{wordsize}mer_{rank}.RData',
	nmf=NMF_METHODS, wordsize=WORDSIZE, rank=RANKS


