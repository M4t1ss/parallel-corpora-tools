#/bin/bash

# Parameters:
#	* directory that contains multiple monolingual files
#	* language code
#	* truecase model
#	* subword unit model

dir=$1
src=$2
tcmodel=$3
bpemodel=$4

mkdir $dir/output

cat $dir/* > $dir/output/corpus.$src


./1-unique.sh \
    $dir/output/corpus.$src \
	$src

./2-identify-language.sh \
    $dir/output/corpus.$src.unique.nonalpha \
    $src

./3-moses-scripts-subword-nmt.sh \
    $dir \
    $src \
    $tcmodel \
    $bpemodel

