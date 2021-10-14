import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-project-plasmids:20211002'

HOSTS = pd.read_csv('data/truepairs.txt', header=None,
    dtype='string', sep='|')
HOSTS = HOSTS[3].unique()
WORDSIZE = [str(x) for x in list(range(2, 5))]

rule all:
    input:
        expand('output/sigma_distance/{wordsize}mer.csv',
            wordsize=WORDSIZE),
        expand('output/mahalanobis_distance/{wordsize}mer.csv',
            wordsize=WORDSIZE)

rule sigma_distance:
    output:
         'output/sigma_distance/{wordsize}mer.csv'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/sigma_distance_{wordsize}.txt'
    log:
        'logs/sigma_distance_{wordsize}.log'
    shell:
        'src/sigma_distance.sh {wildcards.wordsize} {output} >& {log}'

rule mahalanobis_distance:
    output:
         'output/mahalanobis_distance/{host}/{wordsize}mer.csv'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/mahalanobis_distance/{host}/{wordsize}mer.txt'
    log:
        'logs/mahalanobis_distance/{host}/{wordsize}mer.log'
    shell:
        'src/mahalanobis_distance.sh {wildcards.host} {wildcards.wordsize} {output} >& {log}'

def aggregate_mahalanobis_distance(wordsize):
    out = []
    for j in range(len(HOSTS)):
        out.append('output/mahalanobis_distance/' + HOSTS[j] + '/' + wordsize[0] + 'mer.csv')
    return(out)

rule merge_mahalanobis_distance:
    input:
        aggregate_mahalanobis_distance
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