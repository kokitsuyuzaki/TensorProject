library("seqinr")
library("zoo")
library("MASS")
library("tidyverse")
library("DECIPHER")
library("mwTensor")
library("nnTensor")
library("einsum")
library("Rtsne")
library("ROCR")
library("ggplot2")
library("ggbeeswarm")

ROC <- function(score, actual){
    print("prediction")
    pred <- ROCR::prediction(score, actual)
    print("performance")
    auc <- ROCR::performance(pred, "auc")@y.values[[1]]
    nF <- sum(actual == 0)
    nT <- sum(actual == 1)
    x <- pred@fp[[1]] / nF
    y <- pred@tp[[1]] / nT
    list(auc=auc, x=x, y=y)
}

euclid_distance <- function(x, y){
  A2 <- apply(x, 1, function(xx){norm(as.matrix(xx), "F")})^2
  B2 <- apply(y, 1, function(yy){norm(as.matrix(yy), "F")})^2
  AB <- x %*% t(y)
  sqrt(outer(A2, B2, "+") - 2 * AB)
}

manhattan_distance <- function(x, y){
	apply(y, 1, function(yy, x){
    	sum(abs(x - yy))
	}, x=x)
}

delta_distance <- function(x, y, wordsize){
	t(apply_pb(x, 1, function(xx){
	    manhattan_distance(xx, y)
	}) / 4^wordsize)
}

apply_pb <- function(X, MARGIN, FUN, ...)
{
  env <- environment()
  pb_Total <- sum(dim(X)[MARGIN])
  counter <- 0
  pb <- txtProgressBar(min = 0, max = pb_Total,
                       style = 3)

  wrapper <- function(...)
  {
    curVal <- get("counter", envir = env)
    assign("counter", curVal +1 ,envir= env)
    setTxtProgressBar(get("pb", envir= env),
                           curVal +1)
    FUN(...)
  }
  res <- apply(X, MARGIN, wrapper, ...)
  close(pb)
  res
}

euclid_distance2 <- function(x, y){
	apply(y, 1, function(yy, x){
    	sqrt(sum((x - yy)^2))
	}, x=x)
}

host_matrix <- function(seqs_host, wordsize){
  Y <- rollapply(data = seqs_host[[1]],
    width = 5000, by = 5000,
    FUN = function(x){rho(c(x, ' ', rev(comp(x))), wordsize = wordsize)})
  targetY <- grep("Freq", colnames(Y))
  Y <- Y[, targetY]
}

mahalanobis_distance <- function(Y, kmer_plasmid, wordsize){
	if(is.vector(Y)){
		out <- euclid_distance2(Y, kmer_plasmid)
	}else{
		out <- mahalanobis(kmer_plasmid, center=apply(Y, 2, mean),
		    cov=ginv(var(Y)), inverted=TRUE)
	}
	t(out)
}

lowrank_mahalanobis_distance <- function(Y, kmer_plasmid, wordsize, thr=0.95){
	if(is.vector(Y)){
		out <- euclid_distance2(Y, kmer_plasmid)
	}else{
		out <- .lowrank_mahalanobis(Y, kmer_plasmid, thr)
	}
	t(out)
}

.lowrank_mahalanobis <- function(Y, kmer_plasmid, thr){
    # Centering
    centerY <- apply(Y, 2, mean)
    scaledY <- t(t(Y) - centerY)
    scaled_kmer_plasmid <- t(t(kmer_plasmid) - centerY)
    # SVD
    out_svd <- try(svd(scaledY))
    if(class(out_svd) != "try-error"){
      # Truncated
      d <- which(cumsum(out_svd$d)/sum(out_svd$d) <= thr)
      if(length(d) == 0){
        max_d <- length(out_svd$d)
      }else{
        max_d <- max(d)
      }
      # Dimensional Reduction
      score <- t(t(scaled_kmer_plasmid %*% out_svd$v[, seq_len(max_d)]) * (sqrt(nrow(Y)) / out_svd$d[seq_len(max_d)]))
      # Distance from centerY
      out <- apply(score, 1, function(x){
        sqrt(sum(x^2))
      })
    }else{
      out <- t(rep(1E+10, length=nrow(kmer_plasmid)))
    }
    out
}
