<?php
error_reporting(E_ALL & ~E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open input file!");
$outSRC = fopen($source_sentences.".nonalpha", "w") or die("Can't create output file!");
$outTRG = fopen($target_sentences.".nonalpha", "w") or die("Can't create output file!");

$i = 1;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
	
	//Let's see how many non-alphabetic characters are in the sentences...
	$onlyAlpha_source = preg_replace("/[^a-zA-ZēūīāšķļĢžčņĒŪĪĀŠĻĢŽČŅ\n ]+/", "", $sourceSentence);
	$onlyAlpha_target = preg_replace("/[^a-zA-ZēūīāšķļĢžčņĒŪĪĀŠĻĢŽČŅ\n ]+/", "", $targetSentence);
	
	if(
		(strlen($onlyAlpha_source) > strlen($sourceSentence)/2) && 
		(strlen($onlyAlpha_target) > strlen($targetSentence)/2)
		)
	{
        fwrite($outSRC, $sourceSentence);
        fwrite($outTRG, $targetSentence);
	}
    $i++;
}