#/bin/bash

# Requires langid.py (https://github.com/saffsd/langid.py)
#	pip install langid
#
# Parameters - file name and language tag
#	filename.en
#	en
#
# Outputs - files with language tags & confidences per line; bad line numbers; filtered parallel files
#	

langid --line -n < $1 > $1.lang.txt

# Get the IDs of the bad sentences
php find-bad.php $1.lang.txt $2


php filter.php $1 $1.lang.txt.bad