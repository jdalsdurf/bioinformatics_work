#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("filterlong_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"filterlong_in/"+i for i in file_list}}

with open("config_filterlong.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_filterlong.yaml"
rule all:
    input:
        expand("filtlong_out/{sample}_clean.fastq.gz", sample = config["samples"])

rule filtlong:
    input:
        "filterlong_in/{sample}.fastq"
    output:
        name="filterlong_out/{sample}_clean.fastq.gz"
    conda:
        "filtlong_env.yaml"
    shell:
        "filtlong --min_length 500 --keep_percent 95 {input} | gzip > {output.name}"   #### edit min length if not whole bacteria
