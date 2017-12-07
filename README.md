# Parallel Corpora Tools
Tools for filtering and cleaning parallel corpora 
in order to train better neural machine translation systems.

Inspired by the Data Filtering and Data Pre-processing sections of 
[Tilde's](http://tilde.com) [WMT17 paper](http://www.statmt.org/wmt17/pdf/WMT37.pdf). 
This repository includes some of the more basic scripts that can help to get rid of 
the majority of junk from parallel corpora.

Tools included
---------
* [1-find-equal-lines.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/1-find-equal-lines.sh)
	* Gets rid of sentences that are identical in both - the source and target side.
* [2-identify-language.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/2-identify-language.sh)
	* Removes sentences that are not in the specified source or target language.
* [3-unique-parallel.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/3-unique-parallel.sh)
	* Removes duplicate parallel sentences.
* [4-moses-scripts-subword-nmt.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/4-moses-scripts-subword-nmt.sh)
	* The regular Moses tokenizer -> cleaner -> truecaser and subword NMT.

The numbering marks the order that they should be run... I think. 
At least I ran them in that order :D

Requirements
---------
* Python with [langid.py](https://github.com/saffsd/langid.py)
* PHP
* [Moses scripts](https://github.com/moses-smt/mosesdecoder)
* [Subword NMT](https://github.com/rsennrich/subword-nmt)