mapping

samtools view -bS SAMPLE.sam | samtools sort - -o SAMPLE.bam

samtools mpileup -uf REFERENCE.fasta SAMPLE.bam | bcftools call -c | vcfutils.pl vcf2fq > SAMPLE_cns.fastq

seqtk seq -aQ64 -q20 -n N SAMPLE_cns.fastq > SAMPLE_cns.fasta

testing

for i in *T.fastq ; do
	minimap2 -ax map-ont SARB27_CM001274-1_Salmonella_Infantis.fasta $i > ${i%%T.fastq}.sam
done

for i in *i.fastq ; do
	minimap2 -a SARB27_CM001274-1_Salmonella_Infantis.fasta $i > ${i%%i.fastq}.sam
done

for i in *.sam ; do
	samtools view -bS $i | samtools sort - -o ${i.sam}.bam
done

for i in *.bam ; do
	samtools mpileup -uF SARB27_CM001274-1_Salmonella_Infantis.fasta $i | bcftools call -c | vcfutils.pl vcf2fq > ${i.bam}_cns.fastq
done

for i in *cns.fastq ; do
	seqtk seq -aQ64 -q20 -n N $i > ${i.fastq}.fasta
done
