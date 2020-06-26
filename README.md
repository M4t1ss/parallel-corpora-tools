# Corpora Cleaning Tools
Tools for filtering and cleaning parallel and monolingual corpora 
in order to train better (neural) machine translation systems.

Inspired by the Data Filtering and Data Pre-processing sections of 
[Tilde's](http://tilde.com) [WMT17 paper](http://www.statmt.org/wmt17/pdf/WMT37.pdf). 
This repository includes some of the more basic scripts that can help to get rid of 
the majority of junk from parallel corpora.

Tools included
---------
* [parallel](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/parallel) - tools for parallel corpora
* [mono](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/mono) - tools for monolingual corpora

Requirements
---------
* Python with [langid.py](https://github.com/saffsd/langid.py)
* PHP
* [Moses scripts](https://github.com/moses-smt/mosesdecoder)
* [Subword NMT](https://github.com/rsennrich/subword-nmt)

```bash
pip install subword-nmt
pip install langid
```

	
Publications
---------

If you use this tool, please cite the following paper:

Matīss Rikters (2018). "[Impact of Corpora Quality on Neural Machine Translation.](https://arxiv.org/abs/1810.08392)" In Proceedings of the 8th Conference Human Language Technologies - The Baltic Perspective (Baltic HLT 2018) (2018).

```bibtex
@inproceedings{Rikters2018BalticHLT,
	author = {Rikters, Matīss},
	booktitle={In Proceedings of the 8th Conference Human Language Technologies - The Baltic Perspective (Baltic HLT 2018)},
	title = {{Impact of Corpora Quality on Neural Machine Translation}},
	address={Tartu, Estonia},
	year = {2018}
}
```