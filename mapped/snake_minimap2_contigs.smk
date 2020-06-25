#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("fasta_input/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"fasta_input/"+i for i in file_list}}

with open("config_minimap2.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_minimap2.yaml"


rule all:
    input:
        expand("mapped_reads/{sample}_minimap2.bam", sample = config["samples"])

rule bwa_map:
    input:
        "fasta_input/{sample}.fasta"
    params:
        ref="s_suis_reference.fasta"
    output:
        "mapped_reads/{sample}_minimap2.bam"
    shell:
        "minimap2 -ax asm5 {params.ref} {input} | samtools view -hbSF - > {output}"
