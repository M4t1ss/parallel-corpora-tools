#/bin/bash

# Parameters:
# - parallel file names
#	filename.en
#	filename.de
#
# Outputs:
#
# - a file with all parallel sentences concatanated in each single line; 
#	filename.en.filename.de.both
#
# - the same file sorted and unique; 
#	filename.en.filename.de.both.unique
#
# - parallel sorted and unique files; 
#	filename.en.up
#	filename.de.up
#
# - files after removing sentences that contain more non-alphabetical symbols than alphabetical ones
#	filename.en.up.nonalpha
#	filename.de.up.nonalpha

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

# Remove sentences where there are more non-alphabetical symbols than alphabetical
php non-alpha.php $1.up $2.up