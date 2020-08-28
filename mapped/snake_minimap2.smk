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

rule minimap2:
    input:
        "clean_fastq/{sample}.fastq"
    output:
        "mapped_reads/{sample}_minimap2.paf.gz"
    shell:
        "minimap2 -x ava-ont -t4 {input} {input} | gzip -1 > {output}"

rule miniasm:
    input:
        paf="mapped_reads/{sample}_minimap2.paf.gz"
        ref="clean_fastq/{sample}.fastq"
    output:
        "mapped_reads/assembly/{sample}_miniasm.gfa"
    shell:
        "miniasm -f {input.ref} {input.paf} > {output}"
