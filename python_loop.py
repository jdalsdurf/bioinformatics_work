import glob
import os
## get working directory
directory = os.getcwd()
#the directory containing your .jpegs
for file in glob.glob("/mnt/y/jalsdurf/research_projects/avian_orthoreovirus/reo_UCDavis/segment_curration/testing/*.fasta"): #iterates over all files in the directory ending in .jpg
        fa=pyfastx.Fasta(file)
        f = open(( file.rsplit( ".", 1 )[ 0 ] ) + ".txt", "w") #creates a new file using the .jpg filename, but with the .fsv extension
        f.write(str(fa.composition)) #write to the text file
        f.close()
