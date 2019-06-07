#/bin/bash

# Parameters:
# - parallel file names
#	filename.en
#	filename.de
#	en
#	de
#
# Outputs:
#
# - parallel sorted and unique files; 
#	filename.en.up
#	filename.de.up
#
# - files with no repeating source sentences; 
#	filename.en.up.nor
#	filename.de.up.nor
#
# - files with no repeating target sentences; 
#	filename.en.up.nor.up.nor
#	filename.de.up.nor.up.nor
#
# - files after removing sentences that contain more non-alphabetical symbols than alphabetical ones
#	filename.en.up.nonalpha
#	filename.de.up.nonalpha
#
# - files after removing sentences where there are twice as many non-alphabetical symbols 
# - in the source side than there are in te target side or vice versa
#	filename.en.up.nonalpha.nonmatch
#	filename.de.up.nonalpha.nonmatch

# Concatanate sentences from both files
php concat-parallel.php $1 $2

# Remove them from the files
filename=$(basename "$2")
extension="${filename##*.}"
filename="${filename%.*}"

# Sort and get only unique sentence pairs
sort -u $1.$filename.$extension.both > $1.$filename.$extension.both.unique

# Split the sentences back into two
php split-parallel.php $1 $2

# Remove repeating source sentences
php filter-repeating.php $1.up $2.up

# Concatanate sentences from both files with the target file as the first one
php concat-parallel.php $2.up.nor $1.up.nor


# Remove some useless files
rm $1.$filename.$extension.both
rm $1.$filename.$extension.both.unique
filename=$(basename "$1")
extension="${filename##*.}"
filename="${filename%.*}"

# Sort
sort $2.up.nor.$filename.$extension.up.nor.both > $2.up.nor.$filename.$extension.up.nor.both.unique

# Split the sentences back into two
php split-parallel.php $2.up.nor $1.up.nor

# Remove repeating source sentences
php filter-repeating.php $2.up.nor.up $1.up.nor.up

# Remove sentences where there are more non-alphabetical symbols than alphabetical
php non-alpha.php $1.up.nor.up.nor $2.up.nor.up.nor $3 $4

# Remove sentences where there are more non-alphabetical symbols than alphabetical
php non-matching-non-alpha.php $1.up.nor.up.nor.nonalpha $2.up.nor.up.nor.nonalpha $3 $4

# Remove sentences that have repeating tokens (this is more useful for filtering back-translated data)
php repeating-tokens.php $1.up.nor.up.nor.nonalpha.nonmatch $2.up.nor.up.nor.nonalpha.nonmatch

# Remove some useless files
rm $2.up.nor.$filename.$extension.up.nor.both
rm $2.up.nor.$filename.$extension.up.nor.both.unique

