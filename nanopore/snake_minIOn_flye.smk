
#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("filtlong_out/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"filtlong_out/"+i for i in file_list}}

with open("config_flye.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_flye.yaml"
rule all:
    input:
        expand("flye_out/fasta/{sample}_assembly.fasta"", sample = config["samples"])

rule flye:
    input:
        "filtlong_out/{sample}.fastq"
    output:
        directory("flye_out/{sample}"

    conda:
        "flye_env.yaml"  ###### need to have env file in folder

    shell:
        "flye --nano-raw {input} --outdir {output}"

rule flye-rename:
    input:
        "flye_out/{sample}/assembly.fasta"
    output
        "flye_out/{sample}/{sample}_assembly.fasta"
    shell:
        "mv {input} {output}"

rule gather:
    input:
        "flye_out/{sample}/{sample}_assembly.fasta"
    output:
        "flye_out/fasta/{sample}_assembly.fasta"
    shell:
        "cp {input} {output}"
