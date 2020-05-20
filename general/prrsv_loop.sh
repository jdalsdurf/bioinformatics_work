#!/bin/bash
#AB972856_map
vp1=MN073170.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972856.bam
done
