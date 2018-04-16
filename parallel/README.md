# Parallel Corpora Tools
Tools for filtering and cleaning parallel corpora 
in order to train better neural machine translation systems.

Tools included
---------
* [0-do-it-all.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/0-do-it-all.sh)
	* Calls all the proceeding scripts in order.
* [1-find-equal-lines.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/1-find-equal-lines.sh)
	* Gets rid of sentences that are identical in both - the source and target side.
* [2-identify-language.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/2-identify-language.sh)
	* Removes sentences that are not in the specified source or target language.
* [3-unique-parallel.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/3-unique-parallel.sh)
	* Removes duplicate parallel sentences.
	* Removes repeating source sentences aligned to multiple target sentences and repeating target sentences aligned to multiple source sentences.
	* Removes sentences that contain more non-alphabetical symbols than alphabetical ones.
	* Removes sentence pairs where there are significantly more non-alphabetical symbols than on one side compared to the other.
* [4-moses-scripts-subword-nmt.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/4-moses-scripts-subword-nmt.sh)
	* The regular Moses tokenizer -> cleaner -> truecaser and subword NMT.