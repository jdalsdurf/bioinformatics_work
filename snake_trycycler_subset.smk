#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("filterlong_out/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".fastq")[0]:"filtlong_out/"+i for i in file_list}}

with open("config_trycycler.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_trycycler.yaml"


print("Starting trycycler subset workflow")

rule all:
    input:
        expand("trycycler_subset/{sample}", sample = config["samples"]),
#### running flye
rule flye:
    input:
        'filterlong_out/{sample}.fastq.gz'
    output:
        directory("trycycler_subset/{sample}")
    conda:
        "flye_trycycler.yaml"
    shell:
        "trycycler subsample --reads {input} --out_dir {output}"
