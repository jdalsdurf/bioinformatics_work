for file in Fastq/* ; do
  echo mv -v "$file" "${file#*-}"
done
