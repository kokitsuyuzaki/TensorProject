# HTML
mkdir -p report
snakemake -s workflow/download.smk --report report/download.html
snakemake -s workflow/preprocess.smk --report report/preprocess.html
snakemake -s workflow/stratify.smk --report report/stratify.html
snakemake -s workflow/common_dimension.smk --report report/common_dimension.html
snakemake -s workflow/dimreduct.smk --report report/dimreduct.html
snakemake -s workflow/deconvolution.smk --report report/deconvolution.html
snakemake -s workflow/plot.smk --report report/plot.html
