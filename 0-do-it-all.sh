#/bin/bash

# Parameters:
#	directory that contains multiple parallel files with language codes as extensions
#	source language code
#	target language code

dir=$1
src=$2
trg=$3

mkdir $dir/output

cat $dir/*.$src > $dir/output/corpus.$src
cat $dir/*.$trg > $dir/output/corpus.$trg


./1-find-equal-lines.sh \
    $dir/output/corpus.$src \
    $dir/output/corpus.$trg

./2-identify-language.sh \
    $dir/output/corpus.$src.c \
    $dir/output/corpus.$trg.c \
    $src \
    $trg

./3-unique-parallel.sh \
    $dir/output/corpus.$src.c.goodlang \
    $dir/output/corpus.$trg.c.goodlang \
    $src \
    $trg

./4-moses-scripts-subword-nmt.sh \
    $dir \
    $src \
    $trg

