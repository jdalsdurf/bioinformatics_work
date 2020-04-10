#!/bin/bash

for i in *.fastq ; do
        mv "$i" "${i%%.IonXpress*}.fastq"
done
