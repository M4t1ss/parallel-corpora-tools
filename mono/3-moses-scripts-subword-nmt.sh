#/bin/bash

# Requires scripts from Moses - https://github.com/moses-smt/mosesdecoder
# And Subword NMT - https://github.com/rsennrich/subword-nmt
# 
# Prarameters:
#	* directory where the previously processed (corpus.en.unique.nonalpha.goodlang)
#	* language code
#	* truecase model
#	* subword unit model

dir=$1
src=$2
tcmodel=$3
bpemodel=$4

mosesdir=~/tools/mosesdecoder/scripts
subworddir=~/tools/subword-nmt

mkdir $dir/1-tok
mkdir $dir/2-clean
mkdir $dir/3-tc
mkdir $dir/4-bpe

# Tokenize & stuff...
cat $dir/output/corpus.$src.unique.nonalpha.goodlang | \
	$mosesdir/tokenizer/normalize-punctuation.perl -l $src | \
	$mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $src \
	> $dir/1-tok/corpus.tok.$src

# Clean
$mosesdir/training/clean-corpus-n.perl -ratio 3 $dir/1-tok/corpus.tok $src $src $dir/2-clean/corpus.clean.tok 2 80


# Truecase
$mosesdir/recaser/truecase.perl -model $tcmodel < $dir/2-clean/corpus.clean.tok.$src > $dir/3-tc/corpus.tc.$src

# Split into subword units

$subworddir/apply_bpe.py -c $bpemodel < $dir/3-tc/corpus.tc.$src > $dir/4-bpe/corpus.bpe.$src
