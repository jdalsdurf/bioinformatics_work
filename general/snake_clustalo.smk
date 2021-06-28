#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("clustalo_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"clustalo_in/"+i for i in file_list}}

with open("config_clustalo.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_clustalo.yaml"

print("Starting clustalo alignment workflow")

rule all:
    input:
        expand("clustaloOut/{sample}.msa.fasta", sample = config["samples"])

#### running spades
rule clustalo:
    input:
        lambda wildcards: config["samples"][wildcards.sample],
    output:
        "clustaloOut/{sample}.msa.fasta"
    params:
        extra=""
    log:
        "logs/clustalo/test/{sample}.log"
    threads: 8
    wrapper:
        "v0.75.0/bio/clustalo"
