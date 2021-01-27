#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("raw_reads/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split("_L001_")[0]:"raw_reads/"+i for i in file_list}}

with open("config_trimmomatic.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_trimmomatic.yaml"

print("Starting trimming with trimmomatic workflow")

rule all:
    input:
        expand("trimmed/{sample}_L001_R1_001.fastq", sample = config["samples"])

rule trimmomatic_pe:
    input:
        r1="raw_reads/{sample}_L001_R1_001.fastq.gz",
        r2="raw_reads/{sample}_L001_R2_001.fastq.gz"
    output:
        r1="trimmed/{sample}_L001_R1_001.fastq",
        r2="trimmed/{sample}_L001_R2_001.fastq",
        # reads where trimming entirely removed the mate
        r1_unpaired="unpaired/{sample}_unpaired_R1.fastq",
        r2_unpaired="unpaired/{sample}_unpaired_R2.fastq"
    log:
        "logs/trimmomatic/{sample}.log"
    params:
        # list of trimmers (see manual)
        trimmer=["TRAILING:3"],
        # optional parameters
        extra="",
        compression_level="-9"
    threads:
        32
    wrapper:
        "0.68.0/bio/trimmomatic/pe"
