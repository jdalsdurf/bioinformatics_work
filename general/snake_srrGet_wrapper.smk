### config_srrGet.yaml structure
#SRR:
#  - SRR3190736
#  - SRR3190737

###################################################
##  run with:  snakemake -s [file.smk]  --cores 4 -j --use-conda
#################

configfile: "config_srrGet.yaml"

rule all:
    input:
        expand("raw_reads/{accession}_{RF}.fastq", accession = config["SRR"], RF=["1", "2"])
rule get_fastq_pe:
    output:
        # the wildcard name must be accession, pointoing to an SRA number
        "raw_reads/{accession}_1.fastq",
        "raw_reads/{accession}_2.fastq"
    params:
        # optional extra arguments
        extra=""
    threads: 32
    wrapper:
        "0.73.0/bio/sra-tools/fasterq-dump"
