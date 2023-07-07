import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-projects-plasmids:20211018'

WORDSIZE = [str(x) for x in list(range(2, 5))]
RANKS = [str(x) for x in list(range(1, 17))]
METHODS = ['inner_product', 'euclid_distance', 'delta_distance', 'mahalanobis_distance', 'lowrank_mahalanobis_distance', 'mcd_mahalanobis_distance']

rule all:
    input:
    	expand('output/{m}/roc/{wordsize}mer.RData',
    		m=METHODS, wordsize=WORDSIZE),

rule roc:
    output:
        'output/{m}/roc/{wordsize}mer.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/roc_{m}_{wordsize}mer.txt'
    log:
        'logs/roc_{m}_{wordsize}mer.log'
    shell:
        'src/roc.sh {wildcards.m} {wildcards.wordsize} {output} >& {log}'