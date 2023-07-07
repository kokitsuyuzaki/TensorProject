import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")

HOSTS = pd.read_csv('data/truepairs.txt', header=None,
    dtype='string', sep='|')
HOSTS = HOSTS[3].unique()
WORDSIZE = [str(x) for x in list(range(2, 5))]

rule all:
    input:
        expand('output/inner_product/{wordsize}mer.csv',
            wordsize=WORDSIZE),
        expand('output/euclid_distance/{wordsize}mer.csv',
            wordsize=WORDSIZE),
        expand('output/delta_distance/{wordsize}mer.csv',
            wordsize=WORDSIZE),
        expand('output/mahalanobis_distance/{wordsize}mer.csv',
            wordsize=WORDSIZE),
        expand('output/lowrank_mahalanobis_distance/{wordsize}mer.csv',
            wordsize=WORDSIZE),
        expand('output/mcd_mahalanobis_distance/{wordsize}mer.csv',
            wordsize=WORDSIZE)

rule inner_product:
    output:
        'output/inner_product/{wordsize}mer.csv'
    container:
        'docker://koki/tensor-projects-plasmids:20211018'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/inner_product_{wordsize}.txt'
    log:
        'logs/inner_product_{wordsize}.log'
    shell:
        'src/inner_product.sh {wildcards.wordsize} {output} >& {log}'

rule euclid_distance:
    output:
        'output/euclid_distance/{wordsize}mer.csv'
    container:
        'docker://koki/tensor-projects-plasmids:20211018'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/euclid_distance_{wordsize}.txt'
    log:
        'logs/euclid_distance_{wordsize}.log'
    shell:
        'src/euclid_distance.sh {wildcards.wordsize} {output} >& {log}'

rule delta_distance:
    output:
        'output/delta_distance/{wordsize}mer.csv'
    container:
        'docker://koki/tensor-projects-plasmids:20211018'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/delta_distance_{wordsize}.txt'
    log:
        'logs/delta_distance_{wordsize}.log'
    shell:
        'src/delta_distance.sh {wildcards.wordsize} {output} >& {log}'

rule host_matrix:
    output:
        'output/host_matrix/{host}/{wordsize}mer.csv'
    container:
        'docker://koki/tensor-projects-plasmids:20211018'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/host_matrix/{host}/{wordsize}mer.txt'
    log:
        'logs/host_matrix/{host}/{wordsize}mer.log'
    shell:
        'src/host_matrix.sh {wildcards.host} {wildcards.wordsize} {output} >& {log}'

rule mahalanobis_distance:
    input:
        'output/host_matrix/{host}/{wordsize}mer.csv'
    output:
        'output/mahalanobis_distance/{host}/{wordsize}mer.csv'
    container:
        'docker://koki/tensor-projects-plasmids:20211018'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/mahalanobis_distance/{host}/{wordsize}mer.txt'
    log:
        'logs/mahalanobis_distance/{host}/{wordsize}mer.log'
    shell:
        'src/mahalanobis_distance.sh {input} {wildcards.host} {wildcards.wordsize} {output} >& {log}'

def aggregate_mahalanobis_distance(wordsize):
    out = []
    for j in range(len(HOSTS)):
        out.append('output/mahalanobis_distance/' + HOSTS[j] + '/' + wordsize[0] + 'mer.csv')
    return(out)

rule merge_mahalanobis_distance:
    input:
        aggregate_mahalanobis_distance
    container:
        'docker://koki/tensor-projects-plasmids:20211018'
    output:
        'output/mahalanobis_distance/{wordsize}mer.csv'
    wildcard_constraints:
        wordsize='|'.join([re.escape(x) for x in WORDSIZE])
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/merge_mahalanobis_distance_{wordsize}.txt'
    log:
        'logs/merge_mahalanobis_distance_{wordsize}.log'
    shell:
        'src/merge_mahalanobis_distance.sh {wildcards.wordsize} >& {log}'

rule lowrank_mahalanobis_distance:
    input:
        'output/host_matrix/{host}/{wordsize}mer.csv'
    output:
        'output/lowrank_mahalanobis_distance/{host}/{wordsize}mer.csv'
    container:
        'docker://koki/tensor-projects-plasmids:20211018'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/lowrank_mahalanobis_distance/{host}/{wordsize}mer.txt'
    log:
        'logs/lowrank_mahalanobis_distance/{host}/{wordsize}mer.log'
    shell:
        'src/lowrank_mahalanobis_distance.sh {input} {wildcards.host} {wildcards.wordsize} {output} >& {log}'

def aggregate_lowrank_mahalanobis_distance(wordsize):
    out = []
    for j in range(len(HOSTS)):
        out.append('output/lowrank_mahalanobis_distance/' + HOSTS[j] + '/' + wordsize[0] + 'mer.csv')
    return(out)

rule merge_lowrank_mahalanobis_distance:
    input:
        aggregate_lowrank_mahalanobis_distance
    output:
        'output/lowrank_mahalanobis_distance/{wordsize}mer.csv'
    container:
        'docker://koki/tensor-projects-plasmids:20211018'
    wildcard_constraints:
        wordsize='|'.join([re.escape(x) for x in WORDSIZE])
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/merge_lowrank_mahalanobis_distance_{wordsize}.txt'
    log:
        'logs/merge_lowrank_mahalanobis_distance_{wordsize}.log'
    shell:
        'src/merge_lowrank_mahalanobis_distance.sh {wildcards.wordsize} >& {log}'

rule mcd_mahalanobis_distance:
    input:
        'output/host_matrix/{host}/{wordsize}mer.csv'
    output:
        'output/mcd_mahalanobis_distance/{host}/{wordsize}mer.csv'
    container:
        'docker://koki/velocyto:20221005'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/mcd_mahalanobis_distance/{host}/{wordsize}mer.txt'
    log:
        'logs/mcd_mahalanobis_distance/{host}/{wordsize}mer.log'
    shell:
        'src/mcd_mahalanobis_distance.sh {input} {wildcards.wordsize} {output} >& {log}'

def aggregate_mcd_mahalanobis_distance(wordsize):
    out = []
    for j in range(len(HOSTS)):
        out.append('output/mcd_mahalanobis_distance/' + HOSTS[j] + '/' + wordsize[0] + 'mer.csv')
    return(out)

rule merge_mcd_mahalanobis_distance:
    input:
        in1='output/mahalanobis_distance/{wordsize}mer.csv',
        in2=aggregate_mcd_mahalanobis_distance
    output:
        'output/mcd_mahalanobis_distance/{wordsize}mer.csv'
    container:
        'docker://koki/tensor-projects-plasmids:20211018'
    wildcard_constraints:
        wordsize='|'.join([re.escape(x) for x in WORDSIZE])
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/merge_mcd_mahalanobis_distance_{wordsize}.txt'
    log:
        'logs/merge_mcd_mahalanobis_distance_{wordsize}.log'
    shell:
        'src/merge_mcd_mahalanobis_distance.sh {input.in1} {wildcards.wordsize} >& {log}'
