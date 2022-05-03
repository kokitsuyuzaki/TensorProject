import sys
import ot
import numpy as np
from scipy.spatial import distance

# Setting
infile1 = sys.argv[1]
infile2 = sys.argv[2]
outfile1 = sys.argv[3]
outfile2 = sys.argv[4]
# infile1 = "data/toydata2/X_RNA.csv"
# infile2 = "data/toydata2/X_Epi.csv"

# Gromov-Wasserstein Distance
X = np.loadtxt(infile1, delimiter=',', dtype='int64')
Y = np.loadtxt(infile2, delimiter=',', dtype='float64')
Cx = distance.cdist(X, X, metric='euclidean')
Cy = distance.cdist(Y, Y, metric='euclidean')
p = ot.unif(X.shape[0])
q = ot.unif(Y.shape[0])
# 1e+6 - +3がボツ
# 1e+7, 1e+10がボツ
Tt, log0 = ot.partial.entropic_partial_gromov_wasserstein(
    Cx, Cy, p, q, reg=1e+20, m=0.9, verbose=True, log=True)

# GAM
X_GAM = X.shape[0] * np.dot(Tt, Y)

# Output
np.savetxt(outfile1, Tt.T, delimiter=',')
np.savetxt(outfile2, X_GAM, delimiter=',')