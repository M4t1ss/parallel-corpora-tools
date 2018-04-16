<?php
error_reporting(E_ALL & ~E_WARNING);
include("../regular-expressions.php");

//Input parameters
$source_sentences 	= $argv[1];
$source_code     	= $argv[2];

$source_regex       = "/[^" . $regex[$source_code] . '\n ]+/';

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open input file!");
$outSRC = fopen($source_sentences.".nonalpha", "w") or die("Can't create output file!");

$i = 1;
while (($sourceSentence = fgets($inSRC)) !== false) {
	
	//Let's see how many non-alphabetic characters are in the sentences.
	//Add more language specific expressions to regular-expressions.php when working with other languages
	$onlyAlpha_source = preg_replace($source_regex, "", $sourceSentence);
	
	if(strlen($onlyAlpha_source) > strlen($sourceSentence)/2)
	{
        fwrite($outSRC, $sourceSentence);
	}
    $i++;
}