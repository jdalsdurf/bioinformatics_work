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

with open("config_minimap2.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_minimap2.yaml"


rule all:
    input:
        expand("consensus/{sample}_cns.fasta", sample = config["samples"])

rule minimap2:
    input:
        "trimmed/{sample}.fastq"
    params:
        ref="ADL-AP01.fasta"
    output:
        "mapped_reads/{sample}_minimap2.bam"
    shell:
        "minimap2 -ax map-ont {params.ref} {input} | samtools view -bS | samtools sort - -o {output}"

rule freebayes:
	input:
		"mapped_reads/{sample}_minimap2.bam"
	params:
		ref="ADL-AP01.fasta"
	output:
		"variant/{sample}_cns.vcf.gz"
	shell:
		"""
        freebayes -f {params.ref} {input} | bgzip > {output},
        tabix {output}
        """

rule consensus:
	input:
		"variant/{sample}_cns.vcf.gz"
	params:
		ref="ADL-AP01.fasta"
	output:
		"consensus/{sample}_cns.fasta"
	shell:
		"cat {params.ref} | bcftools consensus {input} > {output}"


    # "seqtk seq -aQ64 -q20 -n N {input} > {output}
