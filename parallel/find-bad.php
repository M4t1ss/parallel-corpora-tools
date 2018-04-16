<?php
error_reporting(E_ALL ^ E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];
$source_code 		= $argv[3];
$target_code		= $argv[4];

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open input file!");
$outBAD = fopen($source_sentences.".".basename($target_sentences).".bad", "w") or die("Can't create output file!");



$i = 1;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
	
    if(strpos($sourceSentence, $source_code) == false || strpos($targetSentence, $target_code) == false){
        fwrite($outBAD, $i."\n");
    }
    $i++;
}