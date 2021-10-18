import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-projects-plasmids:20211018'

FILES = pd.read_csv('data/truepairs.txt', header=None,
    dtype='string', sep='|', usecols=[0])[0]
WORDSIZE = [str(x) for x in list(range(2, 5))]

rule all:
    input:
        expand('data/{wordsize}mer_host.csv',
            wordsize=WORDSIZE),
        expand('data/{wordsize}mer_plasmid.csv',
            wordsize=WORDSIZE)

rule rho_host:
    output:
        'data/{f}/{wordsize}mer_host.csv',
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/{f}/{wordsize}mer_host.txt'
    log:
        'logs/{f}/{wordsize}mer_host.log'
    shell:
        'src/rho_host.sh {wildcards.f} {wildcards.wordsize} {output} >& {log}'

rule rho_plasmid:
    output:
        'data/{f}/{wordsize}mer_plasmid.csv',
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/{f}/{wordsize}mer_plasmid.txt'
    log:
        'logs/{f}/{wordsize}mer_plasmid.log'
    shell:
        'src/rho_plasmid.sh {wildcards.f} {wildcards.wordsize} {output} >& {log}'

def aggregate_host_file(wordsize):
    out = []
    for j in range(len(FILES)):
        out.append('data/' + FILES[j] + '/' + wordsize[0] + 'mer_host.csv')
    return(out)

def aggregate_plasmid_file(wordsize):
    out = []
    for j in range(len(FILES)):
        out.append('data/' + FILES[j] + '/' + wordsize[0] + 'mer_plasmid.csv')
    return(out)

rule merge_rho_host:
    input:
        aggregate_host_file
    output:
        'data/{wordsize}mer_host.csv'
    wildcard_constraints:
        wordsize='|'.join([re.escape(x) for x in WORDSIZE])
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/merge_rho_host_{wordsize}.txt'
    log:
        'logs/merge_rho_host_{wordsize}.log'
    shell:
        'src/merge_rho_host.sh {wildcards.wordsize} >& {log}'

rule merge_rho_plasmid:
    input:
        aggregate_plasmid_file
    output:
        'data/{wordsize}mer_plasmid.csv'
    wildcard_constraints:
        wordsize='|'.join([re.escape(x) for x in WORDSIZE])
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/merge_rho_plasmid_{wordsize}.txt'
    log:
        'logs/merge_rho_plasmid_{wordsize}.log'
    shell:
        'src/merge_rho_plasmid.sh {wildcards.wordsize} >& {log}'
