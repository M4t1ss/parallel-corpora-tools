#/bin/bash

# Requires scripts from Moses - https://github.com/moses-smt/mosesdecoder
# And Subword NMT - https://github.com/rsennrich/subword-nmt (pip install subword-nmt)
# 
# Parameters:
#	directory that contains output parallel files from the previous script (corpus.[lang].c.up.nor.up.nor.nonalpha.nonmatch.reptok.goodlang)
#	source language code
#	target language code

dir=$1
src=$2
trg=$3
# The merge operations should be chosen according to the dataset size and languages in question
# 16000 is probably also OK for a large dataset (2M - 10M), but for smaller ones try 8000 or 4000
merge_ops=32000

mosesdir=/home/matiss/tools/mosesdecoder/scripts

mkdir $dir/1-tok
mkdir $dir/2-clean
mkdir $dir/3-tc
mkdir $dir/4-bpe

# Tokenize
cat $dir/output/corpus.$src.c.up.nor.up.nor.nonalpha.nonmatch.reptok.goodlang | $mosesdir/tokenizer/normalize-punctuation.perl -l $src | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $src > $dir/1-tok/corpus.tok.$src
cat $dir/output/corpus.$trg.c.up.nor.up.nor.nonalpha.nonmatch.reptok.goodlang | $mosesdir/tokenizer/normalize-punctuation.perl -l $trg | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $trg > $dir/1-tok/corpus.tok.$trg

# You usually have these as well
cat $dir/dev.$src | $mosesdir/tokenizer/normalize-punctuation.perl -l $src | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $src > $dir/1-tok/dev.tok.$src
cat $dir/dev.$trg | $mosesdir/tokenizer/normalize-punctuation.perl -l $trg | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $trg > $dir/1-tok/dev.tok.$trg
cat $dir/test.$src | $mosesdir/tokenizer/normalize-punctuation.perl -l $src | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $src > $dir/1-tok/test.tok.$src
cat $dir/test.$trg | $mosesdir/tokenizer/normalize-punctuation.perl -l $trg | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l $trg > $dir/1-tok/test.tok.$trg

# Clean
$mosesdir/training/clean-corpus-n.perl $dir/1-tok/corpus.tok $src $trg $dir/2-clean/corpus.clean.tok 2 128

# Train truecasers
$mosesdir/recaser/train-truecaser.perl -corpus $dir/2-clean/corpus.clean.tok.$trg -model $dir/2-clean/truecase-model.$trg
$mosesdir/recaser/train-truecaser.perl -corpus $dir/2-clean/corpus.clean.tok.$src -model $dir/2-clean/truecase-model.$src

# Truecase
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$trg < $dir/2-clean/corpus.clean.tok.$trg > $dir/3-tc/corpus.tc.$trg
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$src < $dir/2-clean/corpus.clean.tok.$src > $dir/3-tc/corpus.tc.$src
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$trg < $dir/1-tok/dev.tok.$trg > $dir/3-tc/dev.tc.$trg
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$src < $dir/1-tok/dev.tok.$src > $dir/3-tc/dev.tc.$src
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$trg < $dir/1-tok/test.tok.$trg > $dir/3-tc/test.tc.$trg
$mosesdir/recaser/truecase.perl -model $dir/2-clean/truecase-model.$src < $dir/1-tok/test.tok.$src > $dir/3-tc/test.tc.$src

# Split into subword units
cat $dir/3-tc/corpus.tc.$trg $dir/3-tc/corpus.tc.$src | subword-nmt learn-bpe -s $merge_ops > $dir/4-bpe/model.bpe

subword-nmt apply-bpe -c $dir/4-bpe/model.bpe < $dir/3-tc/corpus.tc.$trg > $dir/4-bpe/corpus.bpe.$trg &
subword-nmt apply-bpe -c $dir/4-bpe/model.bpe < $dir/3-tc/corpus.tc.$src > $dir/4-bpe/corpus.bpe.$src &

wait

subword-nmt apply-bpe -c $dir/4-bpe/model.bpe < $dir/3-tc/dev.tc.$trg > $dir/4-bpe/dev.bpe.$trg &
subword-nmt apply-bpe -c $dir/4-bpe/model.bpe < $dir/3-tc/dev.tc.$src > $dir/4-bpe/dev.bpe.$src &
subword-nmt apply-bpe -c $dir/4-bpe/model.bpe < $dir/3-tc/test.tc.$trg > $dir/4-bpe/test.bpe.$trg &
subword-nmt apply-bpe -c $dir/4-bpe/model.bpe < $dir/3-tc/test.tc.$src > $dir/4-bpe/test.bpe.$src &

wait
