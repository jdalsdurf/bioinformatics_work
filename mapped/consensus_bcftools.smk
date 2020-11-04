############ works, might need more testing




#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("fastq_subset/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"fastq_subset/"+i for i in file_list}}

with open("config_consensus.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_consensus.yaml"

rule all:
    input:
        expand("mapped_reads/consensus/{sample}_calls.fasta", sample = config["samples"])

rule minimap2:
    input:
        "fastq_subset/{sample}.fastq"
    params:
        ref="pan_genome_linear.fasta"
    output:
        "mapped_reads/{sample}_minimap2.sam"
    shell:
        "minimap2 -a {params.ref} {input} > {output}"

rule samtools_sort:
    input:
        "mapped_reads/{sample}_minimap2.sam"
    params:
        ref="pan_genome_linear.fasta"
    output:
        "mapped_reads/{sample}_minimap2.bam"
    run:
        shell("samtools view -bT {params.ref} {input} | samtools sort > {output}"),
        shell("samtools index {output}")

rule bcftools_mpileup:
    input:
        "mapped_reads/{sample}_minimap2.bam"
    params:
        ref="pan_genome_linear.fasta"
    output:
        "mapped_reads/consensus/{sample}_calls.vcf.gz"
    run:
        shell("bcftools mpileup --threads 8 -f {params.ref} {input} | bcftools call -mv -Oz -o {output}"),
        shell("bcftools index {output}")

rule consensus:
    input:
        "mapped_reads/consensus/{sample}_calls.vcf.gz"
    params:
        ref="pan_genome_linear.fasta"
    output:
        "mapped_reads/consensus/{sample}_calls.fasta"
    shell:
        "cat {params.ref} | bcftools consensus {input} > {output}"
