.ones <- function(n){
	as.matrix(rep(1, length=n))
}

.Uniform <- function(nX){
	out <- rep(0, length=nX)
	out[] <- 1 / nX
	out
}

.diagMat <- function(u){
	l <- nrow(u)
	out <- matrix(0, nrow=l, ncol=l)
	diag(out) <- u
	out
}

.GromovWasserstein <- function(X, Y, num.iter1=30, num.iter2=30,
	epsilon=1e+10, verbose=FALSE){
	nX <- nrow(X)
	nY <- nrow(Y)
	T <- matrix(runif(nX*nY), nrow=nX, ncol=nY)
	p <- .Uniform(nX)
	q <- .Uniform(nY)
	D_X <- as.matrix(dist(X))
	D_Y <- as.matrix(dist(Y))
	# vecX <- as.vector(D_X^2 %*% p) # typo???
	vecX <- rowMeans(D_X^2)
	vecY <- as.vector(q %*% D_Y^2)
	D_XY <- outer(vecX, vecY, "+")
	iter1 <- 1
	while(iter1 <= num.iter1){
    	iter2 <- 1
		if(verbose){
			message(paste0("## Outer Loop: ", iter1, " / ", num.iter1, " ##"))
		}
		D_T <- D_XY - 2 * D_X %*% T %*% t(D_Y)
		u <- p
		v <- q
		# u <- .ones(nX)
		# v <- .ones(nY)
		K <- exp(-D_T / epsilon)
		# Sinkton's Algorithm
		while(iter2 <= num.iter2){
			if(verbose){
				message(paste0("Inner Loop: ", iter2, " / ", num.iter2))
			}
			u <- p / (K %*% v)
			v <- q / (t(K) %*% u)
	        T <- .diagMat(u) %*% T %*% .diagMat(v) # typo???
			iter2 <- iter2 + 1
		}
		iter1 <- iter1 + 1
	}
	# Output
	projY <- nx * T %*% Y
	list(T=T, projY=projY)
}

# X <- matrix(runif(10*20), nrow=10, ncol=20)
# Y <- matrix(runif(15*25), nrow=15, ncol=25)
image.plot(.GromovWasserstein(X, Y, epsilon=1e+10, num.iter1=10, num.iter2=5)$projY)