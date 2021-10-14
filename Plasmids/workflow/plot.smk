from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-project-plasmids:20211002'

WORDSIZE = [str(x) for x in list(range(1, 5))]
TYPES = ['host', 'plasmid']

rule all:
    input:
        expand('plot/pca/{wordsize}mer_{type}.png',
            wordsize=WORDSIZE, type=TYPES),
        expand('plot/tsne/{wordsize}mer_{type}.png',
            wordsize=WORDSIZE, type=TYPES),
        'plot/auc.png'

rule pca:
    output:
        'output/pca/{wordsize}mer_{type}.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/pca_{wordsize}_{type}.txt'
    log:
        'logs/pca_{wordsize}_{type}.log'
    shell:
        'src/pca.sh {wildcards.wordsize} {wildcards.type} {output} >& {log}'

rule tsne:
    input:
        'output/pca/{wordsize}mer_{type}.RData'
    output:
        'output/tsne/{wordsize}mer_{type}.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/tsne_{wordsize}_{type}.txt'
    log:
        'logs/tsne_{wordsize}_{type}.log'
    shell:
        'src/tsne.sh {input} {wildcards.wordsize} {wildcards.type} {output} >& {log}'

rule plot_pca:
    input:
        'output/pca/{wordsize}mer_{type}.RData'
    output:
        'plot/pca/{wordsize}mer_{type}.png'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/plot_pca_{wordsize}_{type}.txt'
    log:
        'logs/plot_pca_{wordsize}_{type}.log'
    shell:
        'src/plot_pca.sh {input} {output} >& {log}'

rule plot_tsne:
    input:
        'output/tsne/{wordsize}mer_{type}.RData'
    output:
        'plot/tsne/{wordsize}mer_{type}.png'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/plot_tsne_{wordsize}_{type}.txt'
    log:
        'logs/plot_tsne_{wordsize}_{type}.log'
    shell:
        'src/plot_tsne.sh {input} {output} >& {log}'

rule plot_auc:
    output:
        'plot/auc.png'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/plot_auc.txt'
    log:
        'logs/plot_auc.log'
    shell:
        'src/plot_auc.sh >& {log}'
