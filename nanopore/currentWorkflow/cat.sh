#!/bin/bash
cat ./barcode01/*.fastq > bc01_all.fastq
cat ./barcode02/*.fastq > bc02_all.fastq
cat ./barcode03/*.fastq > bc03_all.fastq
cat ./barcode04/*.fastq > bc04_all.fastq
cat ./barcode05/*.fastq > bc05_all.fastq
cat ./barcode06/*.fastq > bc06_all.fastq
cat ./barcode07/*.fastq > bc07_all.fastq
cat ./barcode08/*.fastq > bc08_all.fastq
cat ./barcode09/*.fastq > bc09_all.fastq
cat ./barcode10/*.fastq > bc10_all.fastq
cat ./barcode11/*.fastq > bc11_all.fastq
cat ./barcode12/*.fastq > bc12_all.fastq
cat ./unclassified/*.fastq > unclassified_all.fastq

mkdir porechop_in
mv *.fastq ./porechop_in