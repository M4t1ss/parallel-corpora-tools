<?php
error_reporting(E_ALL ^ E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];
//Must be sorted by source!

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open source input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open target input file!");

$outSRC = fopen($source_sentences.".nor", "w") or die("Can't create source output file!");
$outTRG = fopen($target_sentences.".nor", "w") or die("Can't create target output file!");

$outSRC_rem = fopen(str_replace("/output","/output/removed",$source_sentences).".nor", "w") or die("Can't create removed source output file!");
$outTRG_rem = fopen(str_replace("/output","/output/removed",$target_sentences).".nor", "w") or die("Can't create removed target output file!");

$lastSrcTrg = array();
$current = "";
$i = 0;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
    if($sourceSentence != $current){
		if($lastSrcTrg != array()){
			fwrite($outSRC, $lastSrcTrg[1]);
			fwrite($outTRG, $lastSrcTrg[2]);
			$i--;
		}
		
        fwrite($outSRC, $sourceSentence);
        fwrite($outTRG, $targetSentence);
		
		$lastSrcTrg = array();
		$current = $sourceSentence;
    }else{
		$lastSrcTrg[1] = $sourceSentence;
		$lastSrcTrg[2] = $targetSentence;
        fwrite($outSRC_rem, $sourceSentence);
        fwrite($outTRG_rem, $targetSentence);
		$i++;
	}
}

echo "Removed ".$i." sentence pairs with duplicate source sentences aligned to one target sentence\n";