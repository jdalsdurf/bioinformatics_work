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

with open("config_cleanReads.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_cleanReads.yaml"

print("Starting trimming with BBduk, then BBnorm, then Trimmomatic workflow")

rule all:
    input:
        expand("clean_fastq/{sample}_L001_R1_001.fastq", sample = config["samples"])

rule bbduk:
    input:
        r1="raw_reads/{sample}_L001_R1_001.fastq.gz",
        r2="raw_reads/{sample}_L001_R2_001.fastq.gz"
    output:
        r1="bbtools/bbduk/{sample}_L001_R1_001.fastq",
        r2="bbtools/bbduk/{sample}_L001_R2_001.fastq",
    shell:
        """
        bbduk.sh in={input.r1} out={output.r1} qtrim=rl trimq=20 maq=10 minlen=50
        bbduk.sh in={input.r2} out={output.r2} qtrim=rl trimq=20 maq=10 minlen=50
        """

rule bbnorm:
    input:
        r1="bbtools/bbduk/{sample}_L001_R1_001.fastq",
        r2="bbtools/bbduk/{sample}_L001_R2_001.fastq"
    output:
        r1="bbtools/bbnorm/{sample}_L001_R1_001.fastq",
        r2="bbtools/bbnorm/{sample}_L001_R2_001.fastq",
    shell:
        """
        bbnorm.sh in={input.r1} out={output.r1} target=100 min=5
        bbnorm.sh in={input.r2} out={output.r2} target=100 min=5
        """
rule trimmomatic_pe:
    input:
        r1="bbtools/bbnorm/{sample}_L001_R1_001.fastq",
        r2="bbtools/bbnorm/{sample}_L001_R2_001.fastq"
    output:
        r1="clean_fastq/{sample}_L001_R1_001.fastq",
        r2="clean_fastq/{sample}_L001_R2_001.fastq",
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
        "0.72.0/bio/trimmomatic/pe"
