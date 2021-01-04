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
        expand("clean_fastq/{sample}_L001_R1_001.fastq", sample = config["samples"])

rule bbnorm:
    input:
        r1="raw_reads/{sample}_L001_R1_001.fastq.gz",
        r2="raw_reads/{sample}_L001_R2_001.fastq.gz"
    output:
        r1="bbtools/{sample}_L001_R1_001.fastq",
        r2="bbtools/{sample}_L001_R2_001.fastq",
    shell:
        """
        bbnorm.sh in={input.r1} out={output.r1} target=100 min=5
        bbnorm.sh in={input.r2} out={output.r2} target=100 min=5
        """

rule fastp_pe:
    input:
        sample=["bbtools/{sample}_L001_R1_001.fastq", "bbtools/{sample}_L001_R2_001.fastq"]
    output:
        trimmed=["clean_fastq/{sample}_L001_R1_001.fastq", "clean_fastq/{sample}_L001_R2_001.fastq"],
        html="report/pe/{sample}.html",
        json="report/pe/{sample}.json"
    log:
        "logs/fastp/pe/{sample}.log"
    params:
        adapters="--adapter_sequence ACGGCTAGCTA --adapter_sequence_r2 AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC",
        extra="--qualified_quality_phred 25 --length_required 100 --length_limit 151 "
    threads: 12
    wrapper:
        "0.68.0/bio/fastp"
