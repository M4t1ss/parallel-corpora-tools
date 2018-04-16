#/bin/bash

# Parameters:
#	directory that contains multiple parallel files with language codes as extensions
#	source language code

dir=$1
src=$2

mkdir $dir/output

cat $dir/* > $dir/output/corpus.$src


./1-unique-parallel.sh \
    $dir/output/corpus.$src \
	$src

./2-identify-language.sh \
    $dir/output/corpus.$src.unique.nonalpha \
    $src

./3-moses-scripts-subword-nmt.sh \
    $dir \
    $src

