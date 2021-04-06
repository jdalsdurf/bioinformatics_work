#!/bin/bash

for i in *-CT*.fastq ; do
	rename 's/.{3}(.*)/$1/' *
done
