#!/bin/bash
### JDA 20211029
### for renaming fastq file output from illumina


#### rename R1 reads removing all illumina info
for i in *R1*.fastq.gz ; do
        mv "$i" "${i_*}_R1.fastq.gz"
done

#### rename R2 reads removing all illumina info
for i in *R2*.fastq.gz ; do
        mv "$i" "${i_*}_R2.fastq.gz"
done
