#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("blast_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"blast_in/"+i for i in file_list}}

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
        query = "blast_in/{sample}.fasta",
        blastdb=multiext("blastdb/blastdb/ref_viruses_rep_genomes",
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
        "v1.22.0/bio/blast/blastn"