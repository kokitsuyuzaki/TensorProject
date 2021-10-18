import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-projects-plasmids:20211018'

WORDSIZE = [str(x) for x in list(range(2, 5))]
RANKS = [str(x) for x in list(range(1, 17))]
PREVIOUS_METHODS = ['euclid_distance', 'sigma_distance', 'mahalanobis_distance', 'inner_product']
NMF_METHODS = ['nmf_similarity', 'sinmf_similarity', 'jnmf_similarity']

rule all:
    input:
    	expand('output/{previous}/roc/{wordsize}mer.RData',
    		previous=PREVIOUS_METHODS, wordsize=WORDSIZE),
    	expand('output/{nmf}/roc/{wordsize}mer_{rank}.RData',
    		nmf=NMF_METHODS, wordsize=WORDSIZE, rank=RANKS)

rule previous_roc:
    output:
        'output/{previous}/roc/{wordsize}mer.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/previous_roc_{previous}_{wordsize}mer.txt'
    log:
        'logs/previous_roc_{previous}_{wordsize}mer.log'
    shell:
        'src/previous_roc.sh {wildcards.previous} {wildcards.wordsize} {output} >& {log}'

rule nmf_roc:
    output:
        'output/{nmf}/roc/{wordsize}mer_{rank}.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/nmf_roc_{nmf}_{wordsize}mer_{rank}.txt'
    log:
        'logs/nmf_roc_{nmf}_{wordsize}mer_{rank}.log'
    shell:
        'src/nmf_roc.sh {wildcards.nmf} {wildcards.wordsize} {wildcards.rank} {output} >& {log}'
