<?php
error_reporting(E_ALL & ~E_WARNING);
include("../regular-expressions.php");

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];
$source_code     	= $argv[3];
$target_code    	= $argv[4];

$source_regex       = "/[," . $regex[$source_code] . " ]+/";
$target_regex       = "/[," . $regex[$target_code] . " ]+/";

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open source input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open target input file!");

$outSRC = fopen($source_sentences.".nonmatch", "w") or die("Can't create source output file!");
$outTRG = fopen($target_sentences.".nonmatch", "w") or die("Can't create target output file!");

$outSRC_rem = fopen(str_replace("/output","/output/removed",$source_sentences).".nonmatch", "w") or die("Can't create removed source output file!");
$outTRG_rem = fopen(str_replace("/output","/output/removed",$target_sentences).".nonmatch", "w") or die("Can't create removed target output file!");

$i = 0;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
	
	//Let's see how many non-alphabetic characters are in the sentences.
	//Latvian and Estonian diacritics only... Add more if working with other languages
	$noAlpha_source = preg_replace($source_regex, "", $sourceSentence);
	$noAlpha_target = preg_replace($target_regex, "", $targetSentence);
	
	if(
		(strlen($noAlpha_source) < strlen($noAlpha_target)*3) && 
		(strlen($noAlpha_target) < strlen($noAlpha_source)*3)
		)
    {
        fwrite($outSRC, $sourceSentence);
        fwrite($outTRG, $targetSentence);
	}else{
        fwrite($outSRC_rem, $sourceSentence);
        fwrite($outTRG_rem, $targetSentence);
		$i++;
	}
}

echo "Removed ".$i." sentence pairs with a high non-alphabetic character count mismatch between source and target sentences\n";