#/bin/bash

# Parameters - parallel file names
#	filename.en
#	filename.de
# Outputs - equal lines found in both files and cleaned parallel files
#	filename.en.c
#	filename.de.c

php filter-text.php $1 $2