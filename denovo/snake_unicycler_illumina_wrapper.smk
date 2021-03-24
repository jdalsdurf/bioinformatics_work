#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("raw_reads/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split("_")[0]:"raw_reads/"+i for i in file_list}}

with open("config_unicycler.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_unicycler.yaml"

print("Starting Unicycler analysis workflow")

rule all:
    input:
        expand("UnicyclerResult/{sample}/assembly.fasta", sample = config["samples"])

rule unicycler_wrapper:
    input:
        # R1 and R2 short reads:
        paired = expand(
            "raw_reads/{sample}_{read}.fastq",
            read=["1", "2"],
            allow_missing=True
        )
        # Long reads:
        # long = long_reads/{sample}.fq.gz
        # Unpaired reads:
        # unpaired = reads/{sample}.fq.gz
    output:
        "UnicyclerResult/{sample}/assembly.fasta"
    log:
        "logs/{sample}.log"
    params:
        extra="--threads 32"
    wrapper:
        "0.72.0/bio/unicycler"
