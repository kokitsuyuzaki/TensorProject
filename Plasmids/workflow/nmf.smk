import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-project-plasmids:20211014'

WORDSIZE = [str(x) for x in list(range(2, 5))]
RANKS = [str(x) for x in list(range(1, 17))]

rule all:
    input:
        expand('output/nmf_similarity/{wordsize}mer_{rank}.RData',
            wordsize=WORDSIZE, rank=RANKS),
        expand('output/sinmf_similarity/{wordsize}mer_{rank}.RData',
            wordsize=WORDSIZE, rank=RANKS),
        expand('output/jnmf_similarity/{wordsize}mer_{rank}.RData',
            wordsize=WORDSIZE, rank=RANKS)

rule nmf:
    output:
         'output/nmf_similarity/{wordsize}mer_{rank}.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/nmf_{wordsize}mer_{rank}.txt'
    log:
        'logs/nmf_{wordsize}mer_{rank}.log'
    shell:
        'src/nmf.sh {wildcards.wordsize} {wildcards.rank} {output} >& {log}'

rule sinmf:
    output:
         'output/sinmf_similarity/{wordsize}mer_{rank}.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/sinmf_{wordsize}mer_{rank}.txt'
    log:
        'logs/sinmf_{wordsize}mer_{rank}.log'
    shell:
        'src/sinmf.sh {wildcards.wordsize} {wildcards.rank} {output} >& {log}'

rule jnmf:
    output:
         'output/jnmf_similarity/{wordsize}mer_{rank}.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/jnmf_{wordsize}mer_{rank}.txt'
    log:
        'logs/jnmf_{wordsize}mer_{rank}.log'
    shell:
        'src/jnmf.sh {wildcards.wordsize} {wildcards.rank} {output} >& {log}'