#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("trimmed/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"trimmed/"+i for i in file_list}}

with open("config_vcf.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_vcf.yaml"

rule all:
    input:
        expand("calls/{sample}.vcf", sample = config["samples"])

rule bwa_map:
    input:
        "pan_genome_reference.fa",
        "trimmed/{sample}.fastq"
    output:
        "mapped_reads/{sample}.bam"
    shell:
        "bwa mem {input} | samtools view -Sb - > {output}"


rule samtools_sort:
    input:
        "mapped_reads/{sample}.bam"
    output:
        "sorted_reads/{sample}.bam"
    shell:
        "samtools sort -T sorted_reads/{wildcards.sample} "
        "-O bam {input} > {output}"

rule replace_rg:
    input:
        "sorted_reads/{sample}.bam"
    output:
        "fixed-rg/{sample}.bam"
    log:
        "logs/picard/replace_rg/{sample}.log"
    params:
        "RGLB=lib1 RGPL=Torrent RGPU={sample} RGSM={sample} RGID={sample}"
    wrapper:
        "0.59.2/bio/picard/addorreplacereadgroups"

rule samtools_index:
    input:
        "fixed-rg/{sample}.bam"
    output:
        "fixed-rg/{sample}.bam.bai"
    shell:
        "samtools index {input}"
rule freebayes:
    input:
        ref="pan_genome_reference.fa",
        # you can have a list of samples here
        samples=expand("fixed-rg/{sample}.bam", sample = config["samples"]),
        # the matching BAI indexes have to present for freebayes
        indexes="fixed-rg/{sample}.bam.bai"
        # optional BED file specifying chromosomal regions on which freebayes
        # should run, e.g. all regions that show coverage
        #regions="/path/to/region-file.bed"
    output:
        "calls/{sample}.vcf"  # either .vcf or .bcf
    log:
        "logs/freebayes/{sample}.log"
    params:
        extra="",         # optional parameters
        chunksize=100000  # reference genome chunk size for parallelization (default: 100000)
    threads: 2
    wrapper:
        "0.59.2/bio/freebayes"
