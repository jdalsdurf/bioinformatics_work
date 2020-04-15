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

with open("config_fastp.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_fastp.yaml"

print("Starting trimming with FASTP workflow")

rule all:
    input:
        expand("trimmed/{sample}_trimmed.fastq", sample = config["samples"])

rule FASTP:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        trimmed="trimmed/{sample}_trimmed.fastq",
    shell:
        "fastp -i {input} -f 30 -b 400 -o {output}"
