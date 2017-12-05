#/bin/bash

# Requires langid.py (https://github.com/saffsd/langid.py)
#	pip install langid
#
# Parameters - parallel file names
#	filename.en
#	filename.de
#
# Outputs - files with language tags & confidences per line
#	filename.en.lang.txt
#	filename.de.lang.txt

langid --line -n < $1 > $1.lang.txt
langid --line -n < $2 > $2.lang.txt