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

with open("config_fastp.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_fastp.yaml"

print("Starting trimming with FASTP workflow")

rule all:
    input:
        expand("trimmed/{sample}.R1.fastq", sample = config["samples"])

rule fastp_pe:
    input:
        sample=["raw_reads/{sample}_L001_R1_001.fastq", "raw_reads/{sample}_L001_R2_001.fastq"]
    output:
        trimmed=["trimmed/{sample}.R1.fastq", "trimmed/{sample}.R2.fastq"],
        # Unpaired reads separately
        unpaired1="trimmed/pe/{sample}.u1.fastq",
        unpaired2="trimmed/pe/{sample}.u2.fastq",
        # or in a single file
#        unpaired="trimmed/pe/{sample}.singletons.fastq",
        merged="fastp/merged/{sample}.merged.fastq",
        failed="fastp/failed/{sample}.failed.fastq",
        html="fastp/{sample}.html",
        json="fastp/{sample}.json"
    log:
        "logs/fastp/pe/{sample}.log"
    params:
        extra="--merge --trim_poly_g --correction --detect_adapter_for_pe"
    threads: 2
    wrapper:
        "0.78.0/bio/fastp"
