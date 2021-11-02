#!/bin/bash
### JDA 20211029
### for renaming fastq file output from illumina


#### rename R1 reads removing all illumina info
for i in ./raw_reads/*R1*.fastq.gz ; do
        mv "$i" ./raw_reads/"${i%%_}_R1.fastq.gz"
done

#### rename R2 reads removing all illumina info
for i in ./raw_reads/*R2*.fastq.gz ; do
        mv "$i" ./raw_reads/"${i%%_}_R2.fastq.gz"
done
