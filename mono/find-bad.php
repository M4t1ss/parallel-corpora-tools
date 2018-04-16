<?php
error_reporting(E_ALL ^ E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$source_code 		= $argv[2];

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open input file!");
$outBAD = fopen($source_sentences.".bad", "w") or die("Can't create output file!");



$i = 1;
while (($sourceSentence = fgets($inSRC)) !== false) {
    if(strpos($sourceSentence, $source_code) == false){
        fwrite($outBAD, $i."\n");
    }
    $i++;
}