import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/axel:20210326'

FILES = pd.read_csv('data/ftpfilepaths.txt', header=None, dtype='string')
FILES = FILES[0].str.replace('ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/[0-9][0-9][0-9]/[0-9][0-9][0-9]/[0-9][0-9][0-9]/', '')

rule all:
    input:
        expand('data/{f}', f=FILES)

rule data_download:
    output:
        'data/{f}'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/{f}.txt'
    log:
        'logs/{f}.log'
    shell:
        'src/data_download.sh {wildcards.f} >& {log}'
