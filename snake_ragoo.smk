# #!/bin/bash
#
# ref=ssuis_ref.fasta
#
# for i in SRR*.fasta ; do
#         ragoo.py $i $ref
#                 mv "ragoo_output" "${i%%.fasta}_ragooOut"
#                         mv "${i%%.fasta}_ragooOut/ragoo.fasta" "${i%%.fasta}_ragooOut/${i%%}"
#                                 mkdir ragooResults
#                                         cp "${i%%.fasta}_ragooOut/${i%%}" ./ragooResults/
# done

#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in fasta_input/ folder which is output of SPADES snake workflow
for entry in os.scandir("fasta_input/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"fasta_input/"+i for i in file_list}}

with open("config_ragoo.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_ragoo.yaml"

print("Starting ragoo workflow")

rule all:
    input:
        directory("ragoo_out")

rule ragoo:
    input:
        expand("fasta_input/{sample}.fasta" ,sample = config["samples"]),
        "avi_ref01.fasta"
    output:
        "ragoo_out/ragoo.fasta"
    run:
        shell("ragoo.py {input}")
