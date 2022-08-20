import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-projects-parasite:20220625'

rule all:
    input:
        'data/objects.RData'

rule preprocess:
    output:
        'data/objects.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/preprocess.txt'
    log:
        'logs/preprocess.log'
    shell:
        'src/preprocess.sh >& {log}'
