from snakemake.utils import min_version
import re

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/codeczlibjl:20210925'

ID = glob_wildcards('data/{id}/{id2}.fna.gz')[0]

rule all:
    input:
        'data/truepairs.txt',
        'data/non_zero_hosts.txt'

rule divide_plasmid:
    output:
        'data/{id}/plasmid.fna'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/{id}/divide_plasmid_{id}.txt'
    log:
        'logs/{id}/divide_plasmid_{id}.log'
    shell:
        'src/divide_plasmid.sh {wildcards.id} {output} >& {log}'

rule divide_host:
    output:
        'data/{id}/host.fna'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/{id}/divide_host_{id}.txt'
    log:
        'logs/{id}/divide_host_{id}.log'
    shell:
        'src/divide_host.sh {wildcards.id} {output} >& {log}'

rule truepairs:
    input:
        in1='data/{id}/host.fna',
        in2='data/{id}/plasmid.fna'
    output:
        'data/{id}/truepairs.txt'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/truepairs_{id}.txt'
    log:
        'logs/truepairs_{id}.log'
    shell:
        'src/truepairs.sh {input.in1} {input.in2} {output} {wildcards.id} >& {log}'

rule merge_truepairs:
    input:
        expand('data/{id}/truepairs.txt', id=ID)
    output:
        'data/truepairs.txt'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/merge_truepairs.txt'
    log:
        'logs/merge_truepairs.log'
    shell:
        'src/merge_truepairs.sh >& {log}'

rule non_zero_hosts:
    input:
        'data/{id}/host.fna'
    output:
        'data/{id}/non_zero_hosts.txt'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/non_zero_hosts_{id}.txt'
    log:
        'logs/non_zero_hosts_{id}.log'
    shell:
        'src/non_zero_hosts.sh {input} {output} {wildcards.id} >& {log}'

rule merge_non_zero_hosts:
    input:
        expand('data/{id}/non_zero_hosts.txt', id=ID)
    output:
        'data/non_zero_hosts.txt'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/merge_non_zero_hosts.txt'
    log:
        'logs/merge_non_zero_hosts.log'
    shell:
        'src/merge_non_zero_hosts.sh >& {log}'
