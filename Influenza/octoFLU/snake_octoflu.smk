#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/siv/ folder
for entry in os.scandir("octoflu_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".fasta")[0]:"octoflu_in/"+i for i in file_list}}

with open("config_OctoFLU.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_OctoFLU.yaml"

# print("Starting IRMA siv analysis workflow")

rule all:
    input:
        expand("octoflu_out/{sample}_octofluOUT", sample = config["samples"])

rule irma_siv:
    input:
        r1 = 'octoflu_in/{sample}.fasta',
    output:
        directory("octoflu_out/{sample}_octofluOUT")
    run:
        shell("octoFLU.sh {input.r1}")
