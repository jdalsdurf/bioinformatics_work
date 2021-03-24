#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("clean_fastq/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split("_L001_")[0]:"clean_fastq/"+i for i in file_list}}

with open("config_irmaSIV_wholeGenome.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_irmaSIV_wholeGenome.yaml"

# print("Starting IRMA IBV analysis workflow")

rule all:
    input:
        expand("irmaOut/{sample}_irmaOut", sample = config["samples"])

rule irma_IBV:
    input:
        r1 = 'clean_fastq/{sample}_L001_R1_001.fastq.gz',
        r2 = 'clean_fastq/{sample}_L001_R2_001.fastq.gz'
    output:
        directory("irmaOut/{sample}_irmaOut")
    run:
        shell("~/flu-amd/IRMA FLU {input.r1} {input.r2} {output}")
