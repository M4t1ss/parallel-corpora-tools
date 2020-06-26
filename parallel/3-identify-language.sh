#/bin/bash

# Requires langid.py (https://github.com/saffsd/langid.py)
#	pip install langid
#
# Parameters - parallel file names and language tags
#	filename.en
#	filename.de
#	en
#	de
#
# Outputs - files with language tags & confidences per line; bad line numbers; filtered parallel files
#	filename.en.lang.txt
#	filename.de.lang.txt
#	filename.en.lang.txt.filename.de.lang.txt.bad
#	filename.en.lang.txt.goodlang
#	filename.de.lang.txt.goodlang

langid --line -n < $1 > $1.lang.txt &
langid --line -n < $2 > $2.lang.txt &

wait

# Get the IDs of the bad sentences
php find-bad.php $1.lang.txt $2.lang.txt $3 $4

# Remove them from the files
filename=$(basename "$2")
extension="${filename##*.}"
filename="${filename%.*}"

# filter-parallel.php requires PHP to be compiled with additional flags (details here https://www.php.net/manual/en/parallel.setup.php)
# filter.php will do the same job, but it will be slower...
php filter-parallel.php $1 $2 $1.lang.txt.$filename.$extension.lang.txt.bad