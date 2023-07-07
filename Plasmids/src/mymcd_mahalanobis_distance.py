# -*- coding: utf-8 -*-

# Package Loading
import sys
from scipy.spatial import distance
import numpy as np
from sklearn.covariance import MinCovDet

# Arguments passed by Snakemake
args = sys.argv
infile = args[1]
wordsize = args[2]
outfile = args[3]

# Loading
df_x_train = np.loadtxt(infile, delimiter=",", skiprows=1)
plasmid_file = "data/" + wordsize + "mer_plasmid.csv"
df_x_test = np.loadtxt(plasmid_file, delimiter=",", skiprows=1, usecols=list(range(1, 4**int(wordsize)+1)))
plasmid_name = np.loadtxt(plasmid_file, delimiter=",", skiprows=1, usecols=0, dtype=str)

# MCD
if len(df_x_train.shape) == 1:
	anomaly_score_mcd = distance.cdist(df_x_train.reshape(1,-1), df_x_test, metric='euclidean')
	out1 = plasmid_name.reshape(1, anomaly_score_mcd.shape[1])
	out2 = anomaly_score_mcd
else:
	mcd = MinCovDet()
	mcd.fit(df_x_train)
	anomaly_score_mcd = mcd.mahalanobis(df_x_test)
	out1 = plasmid_name.reshape(1, anomaly_score_mcd.shape[0])
	out2 = anomaly_score_mcd.reshape(1, anomaly_score_mcd.shape[0])

# Save
f = open(outfile, 'a')
np.savetxt(f, out1, delimiter=",", fmt="%s")
np.savetxt(f, out2, delimiter=",", fmt="%.5e")
