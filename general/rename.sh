#!/bin/bash

for i in *.fastq ; do
        mv "$i" "${i%%.Ion*}.fastq"
done
