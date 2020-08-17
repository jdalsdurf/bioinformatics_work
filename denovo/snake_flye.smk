#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("raw_reads/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"raw_reads/"+i for i in file_list}}

with open("config_flye.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_flye.yaml"

print("Starting FLYE analysis workflow")

rule all:
    input:
        expand("flye/{sample}_flye", sample = config["samples"])

#### running spades
rule canu:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        directory("flye/{sample}_flye")
    shell:
        "flye --nano-raw {input} --out-dir {output} --threads 16"
