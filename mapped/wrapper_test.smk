#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("trimmed/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"trimmed/"+i for i in file_list}}

with open("config_readgroup.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_readgroup.yaml"

rule all:
    input:
        expand("fixed-rg/{sample}.bam", sample = config["samples"])
rule replace_rg:
    input:
        "sorted_reads/{sample}.bam"
    output:
        "fixed-rg/{sample}.bam"
    log:
        "logs/picard/replace_rg/{sample}.log"
    params:
        "RGLB=lib1 RGPL=illumina RGPU={sample} RGSM={sample}"
    wrapper:
        "0.59.2/bio/picard/addorreplacereadgroups"
