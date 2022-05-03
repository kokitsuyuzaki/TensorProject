# source("src/Functions.R")
# load("data/toydata.RData")

# X.clst <- c(rep(1,90), rep(2,90), rep(3,90), rep(4,30))
# Y.clst <- c(rep(1,60), rep(2,60), rep(3,60), rep(4,20))
# RandZ0 <- matrix(runif(nrow(X_GAM)*ncol(X_GAM)),
#       nrow=nrow(X_GAM), ncol=ncol(X_GAM))

# zeropadding <- function(n){
#     if(n < 10){
#         out <- paste0("0", n)
#     }else{
#         out <- n
#     }
#     out
# }

# bicca_plot <- function(out.dir, X.clst, Y.clst, num.iter=30){
#       for(n in seq_len(num.iter)){
#             tmp <- readRDS(paste0(out.dir, "/iteration", n, ".rds"))
#             # Plot 1
#             png(file=paste0(out.dir, zeropadding(n), ".png"),
#                   width=1500, height=500)
#             layout(t(1:3))
#             image.plot(tmp$s %*% t(tmp$u))
#             image.plot(tmp$Z_est)
#             image.plot(tmp$v %*% t(tmp$r))
#             dev.off()
#             # Plot 2
#             png(file=paste0(out.dir, zeropadding(n), "_X_RNA.png"),
#                   width=1500, height=1500)
#             pairs(tmp$u, col=X.clst, pch=16, cex=2)
#             dev.off()
#             # Plot 3
#             png(file=paste0(out.dir, zeropadding(n), "_X_Epi.png"),
#                   width=1500, height=1500)
#             pairs(tmp$r, col=Y.clst, pch=16, cex=2)
#             dev.off()
#       }
#       # Animation
#       system(paste0("convert -delay 50 ", out.dir, "[0-9][0-9].png ",
#             out.dir, "/iteration.gif"))
#       system(paste0("convert -delay 50 ", out.dir, "[0-9][0-9]_X_RNA.png ",
#             out.dir, "/X_RNA.gif"))
#       system(paste0("convert -delay 50 ", out.dir, "[0-9][0-9]_X_Epi.png ",
#             out.dir, "/X_Epi.gif"))
# }

# # パターンに大きさの序列がないデータ
# # 正解X_GAMあり
# out1 <- try(BiCCA(X=X_RNA, Z0=X_GAM, Y=X_Epi,
#       K = 3,
#       alpha = 0.1,
#       lambda = 0.5,
#       X.clst = X.clst,
#       Y.clst = Y.clst,
#       num.iteration = 30,
#       temp.path = "./bicca/toydata1_trueZ0",
#       tolerance = 1e-10,
#       save = TRUE,
#       block.size =10000))

# bicca_plot("./bicca/toydata1_trueZ0/", X.clst, Y.clst, 30)

# # ランダムX_GAM
# out2 <- try(BiCCA(X=X_RNA, Z0=RandZ0, Y=X_Epi,
#       K = 3,
#       alpha = 0.1,
#       lambda = 0.5,
#       X.clst = c(rep(1,90), rep(2,90), rep(3,90), rep(4,30)),
#       Y.clst = c(rep(1,60), rep(2,60), rep(3,60), rep(4,20)),
#       num.iteration = 30,
#       temp.path = "./bicca/toydata1_randZ0",
#       tolerance = 1e-10,
#       save = TRUE,
#       block.size =10000))

# bicca_plot("./bicca/toydata1_randZ0/", X.clst, Y.clst, 30)

# # パターンに大きさの序列を入れたデータ
# # 正解X_GAMあり
# out3 <- try(BiCCA(X=X_RNA2, Z0=X_GAM, Y=X_Epi2,
#       K = 3,
#       alpha = 0.1,
#       lambda = 0.5,
#       X.clst = c(rep(1,90), rep(2,90), rep(3,90), rep(4,30)),
#       Y.clst = c(rep(1,60), rep(2,60), rep(3,60), rep(4,20)),
#       num.iteration = 30,
#       temp.path = "./bicca/toydata2_trueZ0",
#       tolerance = 1e-10,
#       save = TRUE,
#       block.size =10000))

# bicca_plot("./bicca/toydata2_trueZ0/", X.clst, Y.clst, 30)

# # ランダムX_GAM
# out4 <- try(BiCCA(X=X_RNA2, Z0=RandZ0, Y=X_Epi2,
#       K = 3,
#       alpha = 0.1,
#       lambda = 0.5,
#       X.clst = c(rep(1,90), rep(2,90), rep(3,90), rep(4,30)),
#       Y.clst = c(rep(1,60), rep(2,60), rep(3,60), rep(4,20)),
#       num.iteration = 30,
#       temp.path = "./bicca/toydata2_randZ0",
#       tolerance = 1e-10,
#       save = TRUE,
#       block.size =10000))

# bicca_plot("./bicca/toydata2_randZ0/", X.clst, Y.clst, 30)
