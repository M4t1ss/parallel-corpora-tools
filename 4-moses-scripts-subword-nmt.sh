#/bin/bash

# Requires scripts from Moses - https://github.com/moses-smt/mosesdecoder
# And Subword NMT - https://github.com/rsennrich/subword-nmt

mkdir 1-tok
mkdir 2-clean
mkdir 3-tc
mkdir 4-bpe

# Tokenize & stuff...
cat dcep.pro.en | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l en | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/dcep.tok.en
cat dcep.pro.lv | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l lv | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/dcep.tok.lv

cat europarl.pro.en | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l en | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/europarl.tok.en
cat europarl.pro.lv | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l lv | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/europarl.tok.lv

cat rapid.pro.en | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l en | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/rapid.tok.en
cat rapid.pro.lv | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l lv | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/rapid.tok.lv

cat leta.pro.en | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l en | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/leta.tok.en
cat leta.pro.lv | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l lv | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/leta.tok.lv

cat farewell.pro.en | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l en | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l en > 1-tok/farewell.tok.en
cat farewell.pro.lv | /opt/moses/scripts/tokenizer/normalize-punctuation.perl -l lv | /opt/moses/scripts/tokenizer/tokenizer.perl -a -threads 8 -l lv > 1-tok/farewell.tok.lv

# Clean
/opt/moses/scripts/training/clean-corpus-n.perl -ratio 3 1-tok/dcep.tok en lv 2-clean/dcep.clean.tok 2 80
/opt/moses/scripts/training/clean-corpus-n.perl -ratio 3 1-tok/europarl.tok en lv 2-clean/europarl.clean.tok 2 80
/opt/moses/scripts/training/clean-corpus-n.perl -ratio 3 1-tok/rapid.tok en lv 2-clean/rapid.clean.tok 2 80
/opt/moses/scripts/training/clean-corpus-n.perl -ratio 3 1-tok/leta.tok en lv 2-clean/leta.clean.tok 2 80
/opt/moses/scripts/training/clean-corpus-n.perl -ratio 3 1-tok/farewell.tok en lv 2-clean/farewell.clean.tok 2 80

# Concatanate into one
cat 2-clean/*.en > 2-clean/corpus.tok.en
cat 2-clean/*.lv > 2-clean/corpus.tok.lv

# Train truecasers
/opt/moses/scripts/recaser/train-truecaser.perl -corpus 2-clean/corpus.tok.lv -model 2-clean/truecase-model.lv
/opt/moses/scripts/recaser/train-truecaser.perl -corpus 2-clean/corpus.tok.en -model 2-clean/truecase-model.en

# Truecase
/opt/moses/scripts/recaser/truecase.perl -model 2-clean/truecase-model.lv < 2-clean/corpus.tok.lv > 3-tc/corpus.tc.lv
/opt/moses/scripts/recaser/truecase.perl -model 2-clean/truecase-model.en < 2-clean/corpus.tok.en > 3-tc/corpus.tc.en

# Split into subword units
~/tools/subword-nmt/learn_joint_bpe_and_vocab.py --input 3-tc/corpus.tc.lv 3-tc/corpus.tc.en -s 35000 -o 4-bpe/model.bpe --write-vocabulary 4-bpe/vocab.lv 4-bpe/vocab.en

~/tools/subword-nmt/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.lv --vocabulary-threshold 50 < 3-tc/corpus.tc.lv > 4-bpe/corpus.bpe.lv
~/tools/subword-nmt/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.en --vocabulary-threshold 50 < 3-tc/corpus.tc.en > 4-bpe/corpus.bpe.en

~/tools/subword-nmt/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.lv --vocabulary-threshold 50 < 3-tc/newsdev2017.tc.lv > 4-bpe/newsdev2017.bpe.lv
~/tools/subword-nmt/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.en --vocabulary-threshold 50 < 3-tc/newsdev2017.tc.en > 4-bpe/newsdev2017.bpe.en

~/tools/subword-nmt/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.lv --vocabulary-threshold 50 < 3-tc/newstest2017.tc.lv > 4-bpe/newstest2017.bpe.lv
~/tools/subword-nmt/apply_bpe.py -c 4-bpe/model.bpe --vocabulary 4-bpe/vocab.en --vocabulary-threshold 50 < 3-tc/newstest2017.tc.en > 4-bpe/newstest2017.bpe.en
