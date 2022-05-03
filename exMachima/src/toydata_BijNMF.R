# load("data/toydata.RData")

# # X_GAMが既知の時の同時分解（mwTensor）
# Xs <- list(X_RNA=X_RNA, X_GAM=X_GAM, X_Epi=X_Epi)
# params <- new("CoupledMWCAParams",
#     # Data-wise setting
#     Xs = Xs,
#     mask = list(X_RNA=NULL, X_GAM=NULL, X_Epi=NULL),
#     weights = list(X_RNA=1, X_GAM=1, X_Epi=1),
#     # Common Factor Matrices
#     common_model = list(
#     	X_RNA=list(I1="A1", I2="A2"),
#     	X_GAM=list(I1="A1", I3="A3"),
#     	X_Epi=list(I4="A4", I3="A3")),
#     common_initial = list(A1=NULL, A2=NULL, A3=NULL, A4=NULL),
#     common_algorithms = list(A1="myNMF", A2="myNMF", A3="myNMF", A4="myNMF"),
#     common_iteration = list(A1=30, A2=30, A3=30, A4=30),
#     common_decomp = list(A1=TRUE, A2=TRUE, A3=TRUE, A4=TRUE),
#     common_fix = list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE),
#     common_dims = list(A1=5, A2=5, A3=5, A4=5),
#     common_transpose = list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE),
#     common_coretype = "Tucker",
#     # Other option
#     specific = FALSE,
#     thr = 1e-10,
#     viz = TRUE,
#     figdir = "toymodel",
#     verbose = TRUE
# )
# out1 <- CoupledMWCA(params)

# # X_GAM自体も推定する同時分解（Machima）
# # パターンに大きさの序列がないデータ
# out2 <- Machima(X_RNA, X_Epi,
# 	pseudocount=1e-10, J=3, Beta=1, thr=1e-10,
# 	viz = TRUE, figdir="machima/out2",
#     init="NMF", num.iter=30, verbose=TRUE)
# out3 <- Machima(X_RNA, X_Epi,
# 	pseudocount=1e-10, J=3, Beta=1, thr=1e-10,
# 	viz = TRUE, figdir="machima/out3",
#     init="Random", num.iter=30, verbose=TRUE)

# # パターンに大きさの序列を入れたデータ
# # 初期値のNMF
# out4 <- Machima(X_RNA2, X_Epi2,
# 	pseudocount=1e-10, J=3, Alpha=0.5, Beta=2, thr=1e-10,
# 	viz = TRUE, figdir="machima/out4",
#     init="NMF", num.iter=0, verbose=TRUE)
# # 初期値のNMFからの30iter
# out5 <- Machima(X_RNA2, X_Epi2,
# 	pseudocount=1e-10, J=3, Alpha=0.5, Beta=1, thr=1e-10,
# 	viz = TRUE, figdir="machima/out5",
#     init="NMF", num.iter=30, verbose=TRUE)
# # ランダム初期値からの30iter
# out6 <- Machima(X_RNA2, X_Epi2,
# 	pseudocount=1e-10, J=3, Alpha=0.5, Beta=2, thr=1e-10,
# 	viz = TRUE, figdir="machima/out6",
#     init="Random", num.iter=30, verbose=TRUE)
