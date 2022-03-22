#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("illumina/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split("_")[0]:"illumina/"+i for i in file_list}}

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
            "illumina/{sample}_{read}.fastq.gz",
            read=["R1", "R2"],
            allow_missing=True
        )
        # Long reads:
        long = "nanopore/{sample}_ont.fastq.gz"
        # Unpaired reads:
        # unpaired = reads/{sample}.fq.gz
    output:
        "UnicyclerResult/{sample}/assembly.fasta"
    log:
        "logs/{sample}.log"
    params:
        extra="--threads 32"
    wrapper:
        "v1.3.1/bio/unicycler"
