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
        "calls/all.vcf"


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


rule samtools_index:
    input:
        "sorted_reads/{sample}.bam"
    output:
        "sorted_reads/{sample}.bam.bai"
    shell:
        "samtools index {input}"


rule bcftools_call:
    input:
        fa="pan_genome_reference.fa",
        bam=expand("sorted_reads/{sample}.bam", sample = config["samples"]),
        bai=expand("sorted_reads/{sample}.bam.bai", sample = config["samples"])
    output:
        "calls/all.vcf"
    shell:
        "bcftools mpileup -g -f {input.fa} {input.bam} | "
        "bcftools call -mv - > {output}"

#
# rule freebayes:
# 	input:
# 		"mapped_reads/{sample}_minimap2.bam"
# 	params:
# 		ref="ADL-AP01.fasta"
# 	output:
# 		"variant/{sample}_cns.vcf.gz"
# 	shell:
# 		"""
#         freebayes -f {params.ref} {input} | bgzip > {output},
#         tabix {output}
#         """
