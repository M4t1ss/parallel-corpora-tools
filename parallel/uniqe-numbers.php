<?php
error_reporting(E_ALL & ~E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open source input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open target input file!");

$outSRC = fopen($source_sentences.".repnumbers", "w") or die("Can't create source output file!");
$badNumberArray = [];
$sourcesTarget = [];

$i = 0;
$line = 1;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
	
	$sourceSentence = trim($sourceSentence);
	$targetSentence = trim($targetSentence);
	
	$foundValue = array_search($sourceSentence.$targetSentence, $sourcesTarget);
	
	if(!$foundValue){
		$sourcesTarget[] = $sourceSentence.$targetSentence;
	}else{
		if(!in_array($line, $badNumberArray)){
			$badNumberArray[] = $line;
			$i++;
		}
	}
	
	$line++;
}

echo "Found ".$i." repeating lines\n";

foreach($badNumberArray as $badNumber){
	fwrite($outSRC, $badNumber."\n");
}

fclose($inSRC);
fclose($inTRG);
fclose($outSRC);
