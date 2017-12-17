<?php
error_reporting(E_ALL & ~E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open input file!");
$outSRC = fopen($source_sentences.".nonmatch", "w") or die("Can't create output file!");
$outTRG = fopen($target_sentences.".nonmatch", "w") or die("Can't create output file!");

$i = 1;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
	
	//Let's see how many non-alphabetic characters are in the sentences...
	$noAlpha_source = preg_replace("/[,a-zA-ZēūīāšķļĢžčņĒŪĪĀŠĻĢŽČŅ ]+/", "", $sourceSentence);
	$noAlpha_target = preg_replace("/[,a-zA-ZēūīāšķļĢžčņĒŪĪĀŠĻĢŽČŅ ]+/", "", $targetSentence);
	
	if(
		(strlen($noAlpha_source) < strlen($noAlpha_target)*2) && 
		(strlen($noAlpha_target) < strlen($noAlpha_source)*2)
		)
    {
        fwrite($outSRC, $sourceSentence);
        fwrite($outTRG, $targetSentence);
	}
    $i++;
}