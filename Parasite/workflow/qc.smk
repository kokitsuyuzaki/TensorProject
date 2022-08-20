import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-projects-parasite:20220625'
NUMBERS = [str(x) for x in list(range(1, 11))]
SPECIES = ['at', 'pj']

rule all:
    input:
        expand('plot/qc/{s}_{number}.png',
            s=SPECIES, number=NUMBERS)

rule qc:
    input:
        'data/objects.RData'
    output:
        'plot/qc/{s}_{number}.png'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/qc_{s}_{number}.txt'
    log:
        'logs/qc_{s}_{number}.log'
    shell:
        'src/qc.sh {wildcards.s} {wildcards.number} {input} {output} >& {log}'


