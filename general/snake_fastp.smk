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
        expand("trimmed_fastp/{sample}_L001_R1_001.fastq.gz", sample = config["samples"])

rule FASTP:
rule trimmomatic_pe:
    input:
        r1="raw_reads/{sample}_L001_R1_001.fastq.gz",
        r2="raw_reads/{sample}_L001_R2_001.fastq.gz"
    output:
        r1="trimmed_fastp/{sample}_L001_R1_001.fastq.gz",
        r2="trimmed_fastp/{sample}_L001_R2_001.fastq.gz",
        # reads where trimming entirely removed the mate
        r1_unpaired="unpaired_fastp/{sample}_unpaired_R1.fastq.gz",
        r2_unpaired="unpaired_fastp/{sample}_unpaired_R2.fastq.gz"
    params:
        subset="--reads_to_process 10000"
    shell:
        "fastp --in1 {input.r1} --in2 {input.r2} --out1 {output.r1} --out2 {output.r2}  --unpaired1 {output.r1_unpaired} --unpaired2 {output.r2_unpaired} {params.subset}"
