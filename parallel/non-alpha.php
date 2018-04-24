﻿<?php
error_reporting(E_ALL & ~E_WARNING);
include("../regular-expressions.php");

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];
$source_code     	= $argv[3];
$target_code    	= $argv[4];

$source_regex       = "/[^" . $regex[$source_code] . '\n ]+/';
$target_regex       = "/[^" . $regex[$target_code] . '\n ]+/';

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open source input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open target input file!");

$outSRC = fopen($source_sentences.".nonalpha", "w") or die("Can't create source output file!");
$outTRG = fopen($target_sentences.".nonalpha", "w") or die("Can't create target output file!");

$outSRC_rem = fopen(str_replace("/output","/output/removed",$source_sentences).".nonalpha", "w") or die("Can't create removed source output file!");
$outTRG_rem = fopen(str_replace("/output","/output/removed",$target_sentences).".nonalpha", "w") or die("Can't create removed target output file!");

$i = 0;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
	
	//Let's see how many non-alphabetic characters are in the sentences.
	//Latvian and Estonian diacritics only... Add more if working with other languages
	$onlyAlpha_source = preg_replace($source_regex, "", $sourceSentence);
	$onlyAlpha_target = preg_replace($target_regex, "", $targetSentence);
	
	if(
		(strlen($onlyAlpha_source) > strlen($sourceSentence)/2) && 
		(strlen($onlyAlpha_target) > strlen($targetSentence)/2)
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

echo "Removed ".$i." sentence pairs with more than 50% non-alphabetic characters\n";