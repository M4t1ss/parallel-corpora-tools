# Corpora Cleaning Tools
Tools for filtering and cleaning parallel and monolingual corpora 
in order to train better (neural) machine translation systems.

Inspired by the Data Filtering and Data Pre-processing sections of 
[Tilde's](http://tilde.com) [WMT17 paper](http://www.statmt.org/wmt17/pdf/WMT37.pdf). 
This repository includes some of the more basic scripts that can help to get rid of 
the majority of junk from parallel corpora.

Tools included
---------
* parallel - tools for parallel corpora
* mono - tools for monolingual corpora

Requirements
---------
* Python with [langid.py](https://github.com/saffsd/langid.py)
* PHP
* [Moses scripts](https://github.com/moses-smt/mosesdecoder)
* [Subword NMT](https://github.com/rsennrich/subword-nmt)