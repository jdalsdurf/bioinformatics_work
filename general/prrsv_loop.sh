#!/bin/bash
#AB972856_map
vp1=AB972856.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972856.bam
done

#AB972857_map
vp1=AB972857.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972857.bam
done

#AB972858_map
vp1=AB972858.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972858.bam
done

#AB972859_map
vp1=AB972859.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972859.bam
done

#AB972860_map
vp1=AB972860.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972860.bam
done

#AB972861_map
vp1=AB972861.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972861.bam
done

#AB972862_map
vp1=AB972862.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972862.bam
done

#AB972863_map
vp1=AB972863.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972863.bam
done

#AB972864_map
vp1=AB972864.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972864.bam
done

#AB972865_map
vp1=AB972865.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972865.bam
done

#AB972866_map
vp1=AB972866.fasta
for i in *.fastq ; do
	minimap2 -a $vp1 $i | samtools view -hbSF - > ${i%.fastq}_AB972866.bam
done
