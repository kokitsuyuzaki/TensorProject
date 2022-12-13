# -*- coding: utf-8 -*-

import sys
import numpy as np
import tensorly.decomposition as tsd
import math
import random as rd
import tensorly.cp_tensor as tsc

# Arguments
args = sys.argv
infile = args[1]
outfile = args[2]
cp_rank = int(args[3])
K = int(args[4])

# Functions
def rec_errors(tensor, mask_tensor, rec_tensor):
    x = (1 - mask_tensor) * tensor
    y = (1 - mask_tensor) * rec_tensor
    return np.sum((x - y)**2) / np.sum(mask_tensor)

# Loading Data Tensor
tnsr = np.load(infile)

# Mask Tensor
mask_tnsr = np.copy(tnsr)
mask_tnsr = np.where(mask_tnsr != 0, 1, 0)

# Setting for Random Sampling
indices = np.nonzero(mask_tnsr)
sample_loc = list(range(len(indices[0])))
no_sample = math.floor(len(indices[0]) / K)

# Add Noise to Mask Tensor
mask_tnsr2 = np.copy(mask_tnsr)
target = rd.sample(sample_loc, no_sample)
mask_tnsr2[indices[0][target], indices[1][target], indices[2][target]] = 0

# Non-negative CP Decomposition
# error = tsd.non_negative_parafac(tensor=tnsr, mask=mask_tnsr2, n_iter_max=1000,
#     rank=cp_rank, return_errors=True, verbose=True)[1][-1]
res = tsd.non_negative_parafac(tensor=tnsr, mask=mask_tnsr2, n_iter_max=1000, rank=cp_rank, init="svd", verbose=True)
res = tsc.cp_to_tensor(res)
error = rec_errors(tnsr, mask_tnsr2, res)

# Save
np.savetxt(outfile, [error])
