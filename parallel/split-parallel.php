<?php
error_reporting(E_ALL & ~E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];

//Open files
$inBOTH = fopen($source_sentences.".".basename($target_sentences).".both.unique", "r") or die("Can't open input file!");
$outSRC = fopen($source_sentences.".up", "w") or die("Can't create output file!");
$outTRG = fopen($target_sentences.".up", "w") or die("Can't create output file!");

while (($sentence = fgets($inBOTH)) !== false) {
	$parts = explode("KEDASADALASOTEIKUMU", $sentence);
	fwrite($outSRC, trim(str_replace("\n","",$parts[0]))."\n");
	fwrite($outTRG, trim(str_replace("\n","",$parts[1]))."\n");
}