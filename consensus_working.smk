#### this passes all fastq files to the following programs
#### Might give reference bases
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("trimmed/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"trimmed/"+i for i in file_list}}

with open("config_minimap2.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_minimap2.yaml"
rule all:
    input:
        expand("mapped_reads/consensus/{sample}_output.fasta", sample = config["samples"])

rule minimap2:
    input:
        "trimmed/{sample}.fastq"
    params:
        ref="prrs_mn11b.fasta"
    output:
        "mapped_reads/{sample}_minimap2.sam"
    shell:
        "minimap2 -a {params.ref} {input} > {output}"

rule conversion:
    input:
        "mapped_reads/{sample}_minimap2.sam"
    output:
        "mapped_reads/convert/{sample}_minimap2.bam"
    shell:
        "samtools view -bS {input} {output}"

rule sort:
    input:
        "mapped_reads/convert/{sample}_minimap2.bam"
    output:
        "mapped_reads/srt/{sample}_minimap2.srt.bam"
    shell:
        "samtools sort {input} {output}"

rule view:
    input:
        "mapped_reads/srt/{sample}_minimap2.srt.bam"
    output:
        "mapped_reads/view/{sample}_minimap2.srt.view.bam"
    shell:
        "samtools view -uS {input} | samtools sort - -o {output}"

rule index:
    input:
        "mapped_reads/view/{sample}_minimap2.srt.view.bam"
    output:
        "mapped_reads/index/{sample}_minimap2.srt.view.index.bam"
    shell:
        "samtools index {input}"

rule pileup:
    input:
        "mapped_reads/index/{sample}_minimap2.srt.view.index.bam"
    output:
        "mapped_reads/consensus/{sample}_output.fasta"
    params:
        ref="prrs_mn11b.fasta"
    shell:
        "samtools mpileup -uf {params.ref} {input} | bcftools call -c - | bcftools consensus -f {params.ref} - > {output}"
