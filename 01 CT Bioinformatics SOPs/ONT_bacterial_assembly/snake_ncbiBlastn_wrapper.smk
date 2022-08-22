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

with open("config_blast.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_blast.yaml"

print("Starting NCBI-blast analysis workflow")

rule all:
    input:
        expand("blast_out/{sample}.blast.txt", sample = config["samples"]),

rule blast_nucleotide:
    input:
        query = "{sample}.fasta",
        blastdb=multiext("blastdb/blastdb",
            ".ndb",
            ".nhr",
            ".nin",
            ".not",
            ".nsq",
            ".ntf",
            ".nto"
        )
    output:
        "blast_out/{sample}.blast.txt"
    log:
        "logs/{sample}.blast.log"
    threads:
        2
    params:
        # Usable options and specifiers for the different output formats are listed here:
        # https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/blast/blastn.html.
        format="7 qseqid sseqid evalue staxid ssciname scomname",
        extra=""
    wrapper:
        "v1.7.0/bio/blast/blastn"
