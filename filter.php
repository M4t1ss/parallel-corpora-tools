<?php
error_reporting(E_ALL ^ E_WARNING);

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];
$bad_sentence_num 	= $argv[3];

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open input file!");
$inNUM = fopen($bad_sentence_num, "r") or die("Can't open input file!");
$outSRC = fopen($source_sentences.".goodlang", "w") or die("Can't create output file!");
$outTRG = fopen($target_sentences.".goodlang", "w") or die("Can't create output file!");

$badLineNumbers = file($bad_sentence_num);
foreach($badLineNumbers as &$badLineNumber) {
    $badLineNumber = trim($badLineNumber);
}


$i = 1;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
    if(!in_array($i, $badLineNumbers)){
        fwrite($outSRC, $sourceSentence);
        fwrite($outTRG, $targetSentence);
    }
    $i++;
}