#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("filterlong_out/raven_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".fastq")[0]:"filterlong_out/raven_in/"+i for i in file_list}}

with open("config_raven.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_raven.yaml"


print("Starting raven analysis workflow")

rule all:
    input:
        expand("raven_out/{sample}_raven.fasta", sample = config["samples"]),
#### running flye
rule raven:
    input:
        'filterlong_out/raven_in/{sample}.fastq.gz'
    output:
        directory("raven_out/{sample}_raven.fasta")
    conda:
        "raven_env.yaml"
    shell:
        "raven -t 32 {input} > {output} && rm raven.cereal"
