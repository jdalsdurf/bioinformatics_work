#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("nanopore_fastq/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"nanopore_fastq"+i for i in file_list}}

with open("config_minimap2_ONT.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_minimap2_ONT.yaml"


rule all:
    input:
        expand("mapped_reads/{sample}_minimap2.bam", sample = config["samples"])

rule All-vs-all ONT read Overlap with minimap:
    input:
        "porechop_out/{sample}.fastq"
    output:
        "mapped_reads/{sample}_minimap2.paf.gz"
    shell:
        "minimap2 -x ava-ont -t4 {input} {input} | gzip -1 > {output}"

rule Layout with miniasm:
    input:
        paf="mapped_reads/{sample}_minimap2.paf.gz"
        ref="porechop_out/{sample}.fastq"
    output:
        "mapped_reads/layout/{sample}_miniasm.gfa"
    shell:
        "miniasm -f {input.ref} {input.paf} > {output}"

rule consensus:
    input:
        "mapped_reads/layout/{sample}_miniasm.gfa"
    output:
        "mapped_reads/consensus/{sammple}_miniasm_cns.fasta"
    shell:
        "awk '$1 ~/S/ {print ">"$2"\n"$3}' {input} > {output}"

rule correction 1:
    input:
        reads="mapped_reads/consensus/{sammple}_miniasm_cns.fasta"
        data="porechop_out/{sample}.fastq"
    output:
        "mapped_reads/correction1/{sammple}_miniasm_gfa1.paf"
    shell:
        "minimap2 -t 4 {input.reads} {input.data} > {output}"

rule racon 1:
    input:
        data="porechop_out/{sample}.fastq"
        cor1="mapped_reads/correction1/{sammple}_miniasm_gfa1.paf"
        reads="mapped_reads/consensus/{sammple}_miniasm_cns.fasta"
    output:
        "mapped_reads/correction1/{sammple}_miniasm_racon1.fasta"
    shell:
        "racon -t 4 {input.data} {input.cor1} {input.reads} {output}"

rule correction 2:
    input:
        reads="mapped_reads/correction1/{sammple}_miniasm_racon1.fasta"
        data="porechop_out/{sample}.fastq"
    output:
        "mapped_reads/correction2/{sammple}_miniasm_gfa2.paf
    shell:
        "minimap2 -t 4 {input.reads} {input.data} > {output}"

rule racon 2:
    input:
        data="porechop_out/{sample}.fastq"
        cor2="mapped_reads/correction2/{sammple}_miniasm_gfa2.paf"
        reads="mapped_reads/correction1/{sammple}_miniasm_racon1.fasta"
    output:
        "mapped_reads/correction2/{sammple}_miniasm_racon2.fasta"
    shell:
        "racon -t 4 {input.data} {input.cor1} {input.reads} {output}"
