<?php
error_reporting(E_ALL & ~E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open input file!");
$outBOTH = fopen($source_sentences.".".basename($target_sentences).".both", "w") or die("Can't create output file!");

while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
	fwrite($outBOTH, trim(str_replace("\n","",$sourceSentence))."KEDASADALASOTEIKUMU".trim(str_replace("\n","",$targetSentence))."\n");
}