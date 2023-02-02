#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in blast_in/ folder which is output of SPADES snake workflow
for entry in os.scandir("blast_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"blast_in/"+i for i in file_list}}

with open("config_abricate_argannot.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_argannot.yaml"

print("Starting abricate workflow")

rule abricate_all:
    input:
        expand("blastResults/{sample}_blastVirus.txt", sample = config["samples"]),
        expand("blastResults/{sample}_blast16s.txt", sample = config["samples"]),

        

rule run_all:
    input:
        lambda wildcards: config["samples"][wildcards.sample]

    params:
        blastVirus="ref_viruses_rep_genomes",
        blast16s="16S_ribosomal_RNA",

    output:
        blastVirus="blastResults/{sample}_blastVirus.txt",
        blast16s="blastResults/{sample}_blast16s.txt",

    shell:
        """
        blastn -db /media/nfs/bioinformatics/databases/blastdb/ref_viruses_rep_genomes -max_target_seqs 1 -outfmt '6' -query {input} -out {output.blastVirus}
        blastn -db /media/nfs/bioinformatics/databases/blastdb/16S_ribosomal_RNA -max_target_seqs 1 -outfmt '6' -query {input} -out {output.blast16s}

        """
