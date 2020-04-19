mapping

samtools view -bS SAMPLE.sam | samtools sort - -o SAMPLE.bam

samtools mpileup -uf REFERENCE.fasta SAMPLE.bam | bcftools call -c | vcfutils.pl vcf2fq > SAMPLE_cns.fastq

seqtk seq -aQ64 -q20 -n N SAMPLE_cns.fastq > SAMPLE_cns.fasta

testing
