from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://continuumio/miniconda3:4.4.10'

rule all:
    input:
        'data/ftpfilepaths.txt'

rule data_assembly_summary:
    output:
        'data/assembly_summary.txt'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/assembly_summary.txt'
    log:
        'logs/assembly_summary.log'
    shell:
        'src/data_assembly_summary.sh >& {log}'

rule data_ftpdirpaths:
    input:
        'data/assembly_summary.txt'
    output:
        'data/ftpdirpaths.txt'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/ftpdirpaths.txt'
    log:
        'logs/ftpdirpaths.log'
    shell:
        'src/data_ftpdirpaths.sh >& {log}'

rule data_ftpfilepaths:
    input:
        'data/ftpdirpaths.txt'
    output:
        'data/ftpfilepaths.txt'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/ftpfilepaths.txt'
    log:
        'logs/ftpfilepaths.log'
    shell:
        'src/data_ftpfilepaths.sh >& {log}'
