#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in 01_assembly_results/ folder which is output of SPADES snake workflow
for entry in os.scandir("01_assembly_results/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"01_assembly_results/"+i for i in file_list}}

with open("config_16sBlast.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_16sBlast.yaml"

print("Starting 16sBlast workflow")

rule all:
    input:
        expand("kraken_classified/{sample}_classified.fasta", sample = config["samples"]),

rule blast:
    input:
        lambda wildcards: config["samples"][wildcards.sample],
    output:
        16s = "01_assembly_results/16sBlast/{sample}_16sBlast.txt",
    shell:
        "blastn -query {input} -db /media/nfs/bioinformatics/databases/16S_ribosomal_RNA/ -num_threads 24 -out {output.16s}"
        
