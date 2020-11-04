#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("clean_fastq/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"clean_fastq/"+i for i in file_list}}

with open("config_minimap2.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_minimap2.yaml"

rule all:
    input:
        expand("mapped_reads/consensus/{sample}.cns.fasta", sample = config["samples"])

rule minimap2:
    input:
        "clean_fastq/{sample}.fastq"
    params:
        ref="pan_genome_linear.fasta"
    output:
        "mapped_reads/{sample}_minimap2.bam"
    shell:
        "minimap2 -a {params.ref} {input} | samtools sort > {output}"

rule samtools_index:
    input:
        "mapped_reads/{sample}_minimap2.bam"
    params:
        ref="pan_genome_linear.fasta"
    output:
        "mapped_reads/{sample}_minimap2.bam.bai"
    run:
        shell("samtools index {output}")

rule bcftools_mpileup:
    input:
        "mapped_reads/{sample}_minimap2.bam"
    params:
        ref="pan_genome_linear.fasta"
    output:
        "mapped_reads/consensus/{sample}_calls.fastq"
    run:
        shell("bcftools mpileup --threads 8 -Ou -f {params.ref} {input} | bcftools call -c | vcfutils.pl vcf2fq > {output}"),

rule seqtk:
    input:
        "mapped_reads/consensus/{sample}_calls.fastq"
    params:
        ref="pan_genome_linear.fasta"
    output:
        "mapped_reads/consensus/{sample}.cns.fasta"
    run:
        shell("seqtk seq -aQ64 -n N {input} > {output}"),
