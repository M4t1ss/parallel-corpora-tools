<?php
error_reporting(E_ALL ^ E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];
$bad_sentence_num 	= $argv[3];

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open source input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open target input file!");

$outSRC = fopen($source_sentences.".goodlang", "w") or die("Can't create source output file!");
$outTRG = fopen($target_sentences.".goodlang", "w") or die("Can't create target output file!");

$outSRC_rem = fopen(str_replace("/output","/output/removed",$source_sentences).".goodlang", "w") or die("Can't create removed source output file!");
$outTRG_rem = fopen(str_replace("/output","/output/removed",$target_sentences).".goodlang", "w") or die("Can't create removed target output file!");

$badLineNumbers = file($bad_sentence_num);
foreach($badLineNumbers as &$badLineNumber) {
    $badLineNumber = trim($badLineNumber);
}


$line = 1;
$i = 0;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
    if(!in_array($line, $badLineNumbers)){
        fwrite($outSRC, $sourceSentence);
        fwrite($outTRG, $targetSentence);
    }else{
		$i++;
        fwrite($outSRC_rem, $sourceSentence);
        fwrite($outTRG_rem, $targetSentence);
	}
    $line++;
}

echo "Removed ".$i." sentence pairs with a mismatch between specified and identified language\n";