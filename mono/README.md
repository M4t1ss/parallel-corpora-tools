# Monolingual Corpora Tools
Tools for filtering and cleaning monolingual corpora 
in order to train better neural machine translation systems.

Tools included
---------
* [0-do-it-all.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/mono/0-do-it-all.sh)
	* Calls all the proceeding scripts in order.
	* Parameters - directory of file/files to clean and two letter language code
		* `0-do-it-all.sh /home/matiss/data/english-mono-data en`
* [1-unique.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/mono/1-unique.sh)
	* Removes duplicate sentences.
	* Removes sentences that contain more non-alphabetical symbols than alphabetical ones.
* [2-identify-language.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/mono/2-identify-language.sh)
	* Removes sentences that are not in the specified language.
* [3-moses-scripts-subword-nmt.sh](https://github.com/M4t1ss/parallel-corpora-tools/blob/master/mono/3-moses-scripts-subword-nmt.sh)
	* The regular Moses tokenizer -> cleaner -> truecaser and subword NMT.
