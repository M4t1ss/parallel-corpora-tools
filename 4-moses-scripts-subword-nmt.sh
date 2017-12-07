#/bin/bash

# Requires scripts from Moses - https://github.com/moses-smt/mosesdecoder
# And Subword NMT - https://github.com/rsennrich/subword-nmt
# 
# Hardcoded file names! Watch out!! 

mosesdir=/opt/moses/scripts
subworddir=~/tools/subword-nmt

mkdir 1-tok
mkdir 2-clean
mkdir 3-tc
mkdir 4-bpe

# Tokenize & stuff...
cat dcep.pro.en | /tokenizer/normalize-punctuation.perl -l en | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/dcep.tok.en
cat dcep.pro.lv | $mosesdir/tokenizer/normalize-punctuation.perl -l lv | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/dcep.tok.lv

cat europarl.pro.en | $mosesdir/tokenizer/normalize-punctuation.perl -l en | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/europarl.tok.en
cat europarl.pro.lv | $mosesdir/tokenizer/normalize-punctuation.perl -l lv | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/europarl.tok.lv

cat rapid.pro.en | $mosesdir/tokenizer/normalize-punctuation.perl -l en | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/rapid.tok.en
cat rapid.pro.lv | $mosesdir/tokenizer/normalize-punctuation.perl -l lv | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/rapid.tok.lv

cat leta.pro.en | $mosesdir/tokenizer/normalize-punctuation.perl -l en | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/leta.tok.en
cat leta.pro.lv | $mosesdir/tokenizer/normalize-punctuation.perl -l lv | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/leta.tok.lv

cat farewell.pro.en | $mosesdir/tokenizer/normalize-punctuation.perl -l en | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/farewell.tok.en
cat farewell.pro.lv | $mosesdir/tokenizer/normalize-punctuation.perl -l lv | $mosesdir/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/farewell.tok.lv

# Clean
$mosesdir/training/clean-corpus-n.perl -ratio 3 1-tok/dcep.tok en lv 2-clean/dcep.clean.tok 2 80
$mosesdir/training/clean-corpus-n.perl -ratio 3 1-tok/europarl.tok en lv 2-clean/europarl.clean.tok 2 80
$mosesdir/training/clean-corpus-n.perl -ratio 3 1-tok/rapid.tok en lv 2-clean/rapid.clean.tok 2 80
$mosesdir/training/clean-corpus-n.perl -ratio 3 1-tok/leta.tok en lv 2-clean/leta.clean.tok 2 80
$mosesdir/training/clean-corpus-n.perl -ratio 3 1-tok/farewell.tok en lv 2-clean/farewell.clean.tok 2 80

# Concatanate into one
cat 2-clean/*.en > 2-clean/corpus.tok.en
cat 2-clean/*.lv > 2-clean/corpus.tok.lv

# Train truecasers
$mosesdir/recaser/train-truecaser.perl -corpus 2-clean/corpus.tok.lv -model 2-clean/truecase-model.lv
$mosesdir/recaser/train-truecaser.perl -corpus 2-clean/corpus.tok.en -model 2-clean/truecase-model.en

# Truecase
$mosesdir/recaser/truecase.perl -model 2-clean/truecase-model.lv < 2-clean/corpus.tok.lv > 3-tc/corpus.tc.lv
$mosesdir/recaser/truecase.perl -model 2-clean/truecase-model.en < 2-clean/corpus.tok.en > 3-tc/corpus.tc.en

# Split into subword units
$subworddir/learn_joint_bpe_and_vocab.py --input 3-tc/corpus.tc.lv 3-tc/corpus.tc.en -s 35000 -o 4-bpe/model.bpe --write-vocabulary 4-bpe/vocab.lv 4-bpe/vocab.en

$subworddir/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.lv --vocabulary-threshold 50 < 3-tc/corpus.tc.lv > 4-bpe/corpus.bpe.lv
$subworddir/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.en --vocabulary-threshold 50 < 3-tc/corpus.tc.en > 4-bpe/corpus.bpe.en

$subworddir/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.lv --vocabulary-threshold 50 < 3-tc/newsdev2017.tc.lv > 4-bpe/newsdev2017.bpe.lv
$subworddir/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.en --vocabulary-threshold 50 < 3-tc/newsdev2017.tc.en > 4-bpe/newsdev2017.bpe.en

$subworddir/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.lv --vocabulary-threshold 50 < 3-tc/newstest2017.tc.lv > 4-bpe/newstest2017.bpe.lv
$subworddir/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.en --vocabulary-threshold 50 < 3-tc/newstest2017.tc.en > 4-bpe/newstest2017.bpe.en
