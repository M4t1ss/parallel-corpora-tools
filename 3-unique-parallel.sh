#/bin/bash

# Parameters - parallel file names
#	filename.en
#	filename.de
#
# Outputs - a file with all parallel sentences concatanated in each single line; the same file sorted and unique; parallel sorted and unique files
#	filename.en.filename.de.both
#	filename.en.filename.de.both.unique
#	filename.en.up
#	filename.de.up

# Concatanate sentences from both files
php concat-parallel.php $1 $2

# Remove them from the files
filename=$(basename "$2")
extension="${filename##*.}"
filename="${filename%.*}"

# Sort and get only unique sentence pairs
sort $1.$filename.$extension.both | uniq -u > $1.$filename.$extension.both.unique

# Split the sentences back into two
php split-parallel.php $1 $2
