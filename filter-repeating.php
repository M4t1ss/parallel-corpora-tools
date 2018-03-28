<?php
error_reporting(E_ALL ^ E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];
//Must be sorted by source!

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open input file!");
$outSRC = fopen($source_sentences.".nor", "w") or die("Can't create output file!");
$outTRG = fopen($target_sentences.".nor", "w") or die("Can't create output file!");

// $outSRCr = fopen($source_sentences.".repeat", "w") or die("Can't create output file!");
// $outTRGr = fopen($target_sentences.".repeat", "w") or die("Can't create output file!");

$current = "";
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
    if($sourceSentence != $current){
        fwrite($outSRC, $sourceSentence);
        fwrite($outTRG, $targetSentence);
		$current = $sourceSentence;
    }
	// else{
        // fwrite($outSRCr, $sourceSentence);
        // fwrite($outTRGr, $targetSentence);
	// }
}