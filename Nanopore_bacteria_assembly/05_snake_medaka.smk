configfile: "config_flye.yaml"

rule all:
    input:
        expand("medakaOut/{sample}_medaka", sample = config["samples"]),

########### medaka polishing
rule medaka:
    input:
        fasta = "flyeOut/{sample}_flye/{sample}_assembly.fasta",
        fastq = 'filterlong_out/{sample}.fastq.gz',
    output:
        directory("medakaOut/{sample}_medaka"),
    conda:
        "medaka_env.yaml"
    shell:
        "medaka_consensus -i {input.fastq} -d {input.fasta} -o {output} -t 32"


