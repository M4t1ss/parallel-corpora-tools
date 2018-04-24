#/bin/bash

# Requires scripts from Moses - https://github.com/moses-smt/mosesdecoder
# And Subword NMT - https://github.com/rsennrich/subword-nmt
# 
# Parameters:
#	directory that contains output parallel files from the previous script (corpus.[lang].c.lang.txt.up.nonalpha.nonmatch.goodlang)
#	source language code
#	target language code

dir=$1
src=$2
trg=$3

mosesdir=/opt/moses/scripts
subworddir=~/tools/subword-nmt

mkdir $dir/1-tok
mkdir $dir/2-clean
mkdir $dir/3-tc
mkdir $dir/4-bpe

# Tokenize & stuff...
cat $dir/output/corpus.$src.c.up.nonalpha.nonmatch.reptok.goodlang | $mosesdir/tokenizer/normalize-punctuation.perl -l $src | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $src > $dir/1-tok/corpus.tok.$src
cat $dir/output/corpus.$trg.c.up.nonalpha.nonmatch.reptok.goodlang | $mosesdir/tokenizer/normalize-punctuation.perl -l $trg | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $trg > $dir/1-tok/corpus.tok.$trg

cat dev/newsdev2018.$src | $mosesdir/tokenizer/normalize-punctuation.perl -l $src | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $src > $dir/1-tok/newsdev2018.tok.$src
cat dev/newsdev2018.$trg | $mosesdir/tokenizer/normalize-punctuation.perl -l $trg | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $trg > $dir/1-tok/newsdev2018.tok.$trg

# Clean
$mosesdir/training/clean-corpus-n.perl -ratio 3 $dir/1-tok/corpus.tok $src $trg $dir/2-clean/corpus.clean.tok 2 80

# Train truecasers
$mosesdir/recaser/train-truecaser.perl -corpus $dir/2-clean/corpus.clean.tok.$trg -model $dir/2-clean/truecase-model.$trg
$mosesdir/recaser/train-truecaser.perl -corpus $dir/2-clean/corpus.clean.tok.$src -model $dir/2-clean/truecase-model.$src

# Truecase
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$trg < $dir/2-clean/corpus.clean.tok.$trg > $dir/3-tc/corpus.tc.$trg
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$src < $dir/2-clean/corpus.clean.tok.$src > $dir/3-tc/corpus.tc.$src
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$trg < $dir/1-tok/newsdev2018.tok.$trg > $dir/3-tc/newsdev2018.tc.$trg
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$src < $dir/1-tok/newsdev2018.tok.$src > $dir/3-tc/newsdev2018.tc.$src

# Split into subword units
$subworddir/learn_joint_bpe_and_vocab.py --input $dir/3-tc/corpus.tc.$trg $dir/3-tc/corpus.tc.$src -s 35000 -o $dir/4-bpe/model.bpe --write-vocabulary $dir/4-bpe/vocab.$trg $dir/4-bpe/vocab.$src

$subworddir/apply_bpe.py -c $dir/4-bpe/model.bpe --vocabulary $dir/4-bpe/vocab.$trg --vocabulary-threshold 50 < $dir/3-tc/corpus.tc.$trg > $dir/4-bpe/corpus.bpe.$trg
$subworddir/apply_bpe.py -c $dir/4-bpe/model.bpe --vocabulary $dir/4-bpe/vocab.$src --vocabulary-threshold 50 < $dir/3-tc/corpus.tc.$src > $dir/4-bpe/corpus.bpe.$src

$subworddir/apply_bpe.py -c $dir/4-bpe/model.bpe --vocabulary $dir/4-bpe/vocab.$trg --vocabulary-threshold 50 < $dir/3-tc/newsdev2018.tc.$trg > $dir/4-bpe/newsdev2018.bpe.$trg
$subworddir/apply_bpe.py -c $dir/4-bpe/model.bpe --vocabulary $dir/4-bpe/vocab.$src --vocabulary-threshold 50 < $dir/3-tc/newsdev2018.tc.$src > $dir/4-bpe/newsdev2018.bpe.$src
