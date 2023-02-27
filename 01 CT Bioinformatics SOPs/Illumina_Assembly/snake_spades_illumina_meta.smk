#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("raw_reads/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split("_R")[0]:"raw_reads/"+i for i in file_list}}

with open("config_spades.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_spades.yaml"

print("Starting SPADES analysis workflow")

rule all:
    input:
        expand("spadesOut/{sample}_spades", sample = config["samples"])

#### running spades
rule spades:
    input:
        r1 = 'raw_reads/{sample}_R1.fastq.gz',
        r2 = 'raw_reads/{sample}_R2.fastq.gz'
    output:
        directory("spadesOut/{sample}_spades")
    shell:
        "spades.py --meta --threads 60 -1 {input.r1} -2 {input.r2} -o {output}"
