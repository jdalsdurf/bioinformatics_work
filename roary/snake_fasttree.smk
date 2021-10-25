#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("roary_gff/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"roary_gff/"+i for i in file_list}}

with open("config_roary.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front

configfile: "config_roary.yaml"

print("Starting fasttree analysis workflow")

rule all:
    input:
        "roary_results/core_gene_alignment.newick"

rule run_fasttree:
 input:
  "roary_results/core_gene_alignment.aln"
 output:
  "roary_results/core_gene_alignment.newick"
 params:
  outdir = "roary_results"
 conda:
  "fasttree_env.yaml"

 shell:
  """
  fasttree -nt -gtr {input} > {output}
  """
# rule fast_tree:
#  input:
#   aln = "roary_results/core_gene_alignment.aln"
#  output:
#   tree = "roary_results/core_gene_alignment.newick"
#  shell:
#   """
#   fasttree -nt -gtr {input.aln} > {output.tree}
#   """
