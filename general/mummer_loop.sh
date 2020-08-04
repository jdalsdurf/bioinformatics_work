#!/bin/bash
#AB972856_map
ref=prrs_mn11b_linear.fasta
for j in *.fna ; do
    mkdir ${j%%.fna}_scaffold
done

for i in *.fna ; do
  haphpipe assemble_scaffold --contigs_fa $i --ref_fa $ref --outdir ${i%%.fna}_scaffold
    mv "${i%%.fna}_scaffold/scaffold_assembly.fa" "${i%%.fna}_scaffold/${i%%.fna}_scaffold_assembly.fasta"
done
