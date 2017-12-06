#/bin/bash

# # # # # # Requires langid.py (https://github.com/saffsd/langid.py)
# # # # # #	pip install langid
# # # # # #
# # # # # # Parameters - parallel file names and language tags
# # # # # #	filename.en
# # # # # #	filename.de
# # # # # #	en
# # # # # #	de
# # # # # #
# # # # # # Outputs - files with language tags & confidences per line; bad line numbers; filtered parallel files
# # # # # #	filename.en.lang.txt
# # # # # #	filename.de.lang.txt
# # # # # #	filename.en.lang.txt.filename.de.lang.txt.bad
# # # # # #	filename.en.lang.txt.goodlang
# # # # # #	filename.de.lang.txt.goodlang

# Concatanate sentences from both files
php concat-parallel.php $1 $2

# Remove them from the files
filename=$(basename "$2")
extension="${filename##*.}"
filename="${filename%.*}"

# Sort and get only uniqe sentence pairs
sort $1.$filename.$extension.both | uniq -u > $1.$filename.$extension.both.uniqe

# Split the sentences back into two
php split-parallel.php $1 $2
