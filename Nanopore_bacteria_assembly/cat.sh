!/bin/bash

# This file should be in the fastq file copied from the nanopore run.
# Saved in a folder on desktop

#### COMMENT OUT THE BARCODES NOT PRESENT OR ERROR WILL OCCURE.
#### NOT CRITICAL BUT WILL GENERATE ERROR

cat ./fastq_pass/barcode01/*.fastq > bc01_all.fastq
cat ./fastq_pass/barcode02/*.fastq > bc02_all.fastq
cat ./fastq_pass/barcode03/*.fastq > bc03_all.fastq
cat ./fastq_pass/barcode04/*.fastq > bc04_all.fastq
cat ./fastq_pass/barcode05/*.fastq > bc05_all.fastq
cat ./fastq_pass/barcode06/*.fastq > bc06_all.fastq
cat ./fastq_pass/barcode07/*.fastq > bc07_all.fastq
cat ./fastq_pass/barcode08/*.fastq > bc08_all.fastq
cat ./fastq_pass/barcode09/*.fastq > bc09_all.fastq
cat ./fastq_pass/barcode10/*.fastq > bc10_all.fastq
cat ./fastq_pass/barcode11/*.fastq > bc11_all.fastq
cat ./fastq_pass/barcode12/*.fastq > bc12_all.fastq
cat ./fastq_pass/unclassified/*.fastq > unclassified_all.fastq

mkdir filterlong_in
mv *.fastq ./filterlong_in
