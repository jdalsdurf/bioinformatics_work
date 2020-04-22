#!/bin/bash

for i in *.fastq ; do
	bbnorm.sh in=$i out=${i%.fastq}_norm.fastq target=100 min=5
done
