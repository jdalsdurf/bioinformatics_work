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

with open("config_bbnorm_and_trimmomatic.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_bbnorm_and_trimmomatic.yaml"

print("Starting trimming with bbnorm workflow")

rule all:
    input:
        expand("trimmomatic/{sample}_L001_R1_001.fastq", sample = config["samples"])

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
rule trimmomatic_pe:
    input:
        r1="bbtools/{sample}_L001_R1_001.fastq",
        r2="bbtools/{sample}_L001_R2_001.fastq",
    output:
        r1="trimmomatic/{sample}_L001_R1_001.fastq",
        r2="trimmomatic/{sample}_L001_R2_001.fastq",
        # reads where trimming entirely removed the mate
        r1_unpaired="trimmomatic/unpaired/{sample}_unpaired_R1.fastq",
        r2_unpaired="trimmomatic/unpaired/{sample}_unpaired_R2.fastq"
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
