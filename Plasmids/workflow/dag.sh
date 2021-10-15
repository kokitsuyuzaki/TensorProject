# DAG graph
snakemake -s workflow/identifier.smk --rulegraph | dot -Tpng > plot/identifier.png
snakemake -s workflow/download.smk --rulegraph | dot -Tpng > plot/download.png
snakemake -s workflow/divide_plasmid_host.smk --rulegraph | dot -Tpng > plot/divide_plasmid_host.png
snakemake -s workflow/stats.smk --rulegraph | dot -Tpng > plot/stats.png
snakemake -s workflow/rho.smk --rulegraph | dot -Tpng > plot/rho.png
snakemake -s workflow/distance.smk --rulegraph | dot -Tpng > plot/distance.png
snakemake -s workflow/nmf.smk --rulegraph | dot -Tpng > plot/nmf.png
snakemake -s workflow/roc.smk --rulegraph | dot -Tpng > plot/roc.png
snakemake -s workflow/plot.smk --rulegraph | dot -Tpng > plot/plot.png
