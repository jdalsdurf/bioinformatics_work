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
        expand("bcf_consensus/{sample}_cns.fasta", sample = config["samples"])

rule minimap2:
    input:
        "trimmed/{sample}.fastq"
    params:
        ref="AviparaA-JF4211.fasta"
    output:
        "mapped_reads/{sample}_minimap2.bam"
    shell:
        "minimap2 -ax map-ont {params.ref} {input} | samtools view -bS | samtools sort - -o {output}"

# rule variant:
# 	input:
# 		"mapped_reads/{sample}_minimap2.bam"
# 	params:
# 		ref="AviparaA-JF4211.fasta"
# 	output:
# 		"variant/{sample}_cns.fastq"
# 	shell:
# 		"samtools mpileup -uf {params.ref} {input} | bcftools call -c | vcfutils.pl vcf2fq > {output}"

rule bcftools:
	input:
		"mapped_reads/{sample}_minimap2.bam"
	params:
		ref="AviparaA-JF4211.fasta"
	output:
		"variant/{sample}_cns.vcf.gz"
	shell:
		"bcftools mpileup -Ou -f {params.ref} {input} | bcftools call -mv -Oz {output}"

rule consensus:
	input:
		"variant/{sample}_cns.vcf.gz"
	params:
		ref="AviparaA-JF4211.fasta"
	output:
		"bcf_consensus/{sample}_cns.fasta"
	shell:
		"cat {params.ref} | bcftools consensus {input} > {output}"









# seqtk seq -aQ64 -q20 -n N SAMPLE_cns.fastq > SAMPLE_cns.fasta
#
# testing
#
# for i in *T.fastq ; do
# 	minimap2 -ax map-ont SARB27_CM001274-1_Salmonella_Infantis.fasta $i > ${i%%T.fastq}.sam
# done
#
# for i in *i.fastq ; do
# 	minimap2 -a SARB27_CM001274-1_Salmonella_Infantis.fasta $i > ${i%%i.fastq}.sam
# done
#
# for i in *.sam ; do
# 	samtools view -bS $i | samtools sort - -o ${i.sam}.bam
# done
#
# for i in *.bam ; do
# 	samtools mpileup -uF SARB27_CM001274-1_Salmonella_Infantis.fasta $i | bcftools call -c | vcfutils.pl vcf2fq > ${i.bam}_cns.fastq
# done
#
# for i in *cns.fastq ; do
# 	seqtk seq -aQ64 -q20 -n N $i > ${i.fastq}.fasta
# done
