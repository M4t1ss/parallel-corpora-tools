#/bin/bash

# Parameters:
# - File names and language code
#	filename.en
#	en
#
# Outputs:
#	filename.en.unique
#	filename.en.unique.nonalpha


# Sort and get only unique sentence pairs
sort $1 | uniq -u > $1.unique


# Remove sentences where there are more non-alphabetical symbols than alphabetical
php non-alpha.php $1.unique $2


