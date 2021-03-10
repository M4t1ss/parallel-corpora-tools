<?php
error_reporting(E_ALL & ~E_WARNING);
include("../regular-expressions.php");

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];
$source_code     	= $argv[3];
$target_code    	= $argv[4];

$source_regex       = "/[^" . $regex[$source_code] . '\n ]+/';
$target_regex       = "/[^" . $regex[$target_code] . '\n ]+/';
$source_regexN      = "/[," . $regex[$source_code] . " ]+/";
$target_regexN      = "/[," . $regex[$target_code] . " ]+/";

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open source input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open target input file!");

$outSRC = fopen($source_sentences.".badnumbers", "w") or die("Can't create source output file!");
$badNumberArray = [];

$i = $j = $k = 0;
$line = 1;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
	$bad = false;
	
	$sourceSentence = trim($sourceSentence);
	$targetSentence = trim($targetSentence);
	
	//Let's see how many non-alphabetic characters are in the sentences.
	//Latvian and Estonian diacritics only... Add more if working with other languages
	$onlyAlpha_source = preg_replace($source_regex, "", $sourceSentence);
	$onlyAlpha_target = preg_replace($target_regex, "", $targetSentence);
	
	// More than half are non-alpha
	if(
		(strlen($onlyAlpha_source) < strlen($sourceSentence)/2) || 
		(strlen($onlyAlpha_target) < strlen($targetSentence)/2)
		)
	{
		if(!in_array($line, $badNumberArray)){
			$badNumberArray[] = $line;
			$i++;
			$bad = true;
		}
	}
	
	// Non-alpha on one side more than 5x non-alpha on the other side
	$noAlpha_source = preg_replace($source_regexN, "", $sourceSentence);
	$noAlpha_target = preg_replace($target_regexN, "", $targetSentence);
	
	$srcNonAlphaLen = strlen(trim($noAlpha_source));
	$trgNonAlphaLen = strlen(trim($noAlpha_target));
	
	if(
		!$bad &&
		$srcNonAlphaLen != $trgNonAlphaLen &&
		(
			($srcNonAlphaLen > ($trgNonAlphaLen>0?$trgNonAlphaLen:1) * 5) || 
			($trgNonAlphaLen > ($srcNonAlphaLen>0?$srcNonAlphaLen:1) * 5)
		)
	)
    {
		if(!in_array($line, $badNumberArray)){
			$badNumberArray[] = $line;
			$j++;
			$bad = true;
		}
	}
	
	// Repeating tokens
	$repSrc = replace_repetitions($sourceSentence);
	$repTrg = replace_repetitions($targetSentence);
	
    if(
		!$bad && 
		(
			$repSrc != $sourceSentence || 
			$repTrg != $targetSentence
		)
	){
		if(!in_array($line, $badNumberArray)){
			$badNumberArray[] = $line;
			$k++;
			$bad = true;
		}	
	}	
	
	$line++;
}

echo "Found ".$i." sentence pairs with more than 50% non-alphabetic characters\n";
echo "Removed ".$j." sentence pairs with a high non-alphabetic character count mismatch between source and target sentences\n";
echo "Removed ".$k." sentence pairs with repeating tokens\n";

foreach($badNumberArray as $badNumber){
	fwrite($outSRC, $badNumber."\n");
}

fclose($inSRC);
fclose($inTRG);
fclose($outSRC);



// Reusing functions from C-3MA WMT 2017 submission
// https://github.com/M4t1ss/C-3MA

function sortByLength($a,$b){
  if($a == $b) return 0;
  return (strlen($a) > strlen($b) ? -1 : 1);
} 

function replace_repetitions($str){
	
    //escape special chars
	$str = str_replace("&quot;", "quot-quot", $str);
	$str = str_replace("&amp;", "amp-amp", $str);
	$str = str_replace("&apos;", "apos-apos", $str);
	$str = str_replace("&#124;", "124-124", $str);
	$str = str_replace("&#91;", "91-91", $str);
	$str = str_replace("&#93;", "93-93", $str);
	$str = str_replace("&lt;", "lt-lt", $str);
	$str = str_replace("&gt;", "gt-gt", $str);
	$str = str_replace(" , ", " comma-comma ", $str);
	$str = str_replace(" , ", " comma-comma ", $str);

	$results = get_repetitions($str);
	$workaround = $results;
	usort($results,'sortByLength');
	
	$prepositions = array("of", "at", "by", "but", "for", "to", "with", "without", "of the", "in the");
	while(count($results) > 0){
		$workaround = $results;
		foreach($results as $result){
			$str = repetitions_with_prepositions($str, $result, $prepositions);
		}
		$results = get_repetitions($str);
		usort($results,'sortByLength');
		if(count(array_diff($workaround, $results)) == 0)
			break;
	}
	
	$str = str_replace("quot-quot", "&quot;", $str);
	$str = str_replace("amp-amp", "&amp;", $str);
	$str = str_replace("apos-apos", "&apos;", $str);
	$str = str_replace("124-124", "&#124;", $str);
	$str = str_replace("91-91", "&#91;", $str);
	$str = str_replace("93-93", "&#93;", $str);
	$str = str_replace("lt-lt", "&lt;", $str);
	$str = str_replace("gt-gt", "&gt;", $str);
	$str = str_replace(" comma-comma ", " , ", $str);
	
	return $str;
}

function repetitions_with_prepositions($str, $repetition, $prepositions){
	$str = str_replace(" ".$repetition." ".$repetition." ", " ".$repetition." ", $str);
	$str = str_replace(" ".$repetition." ".$repetition."\n", " ".$repetition."\n", $str);
	if(strpos($str, $repetition." ".$repetition) == 0){
		$str = str_replace($repetition." ".$repetition." ", $repetition." ", $str);
		$str = str_replace($repetition." ".$repetition."\n", $repetition."\n", $str);
	}
	foreach($prepositions as $preposition){
		$str = str_replace(" ".$repetition." ".$preposition." ".$repetition." ", " ".$repetition." ", $str);
		$str = str_replace(" ".$repetition." ".$preposition." ".$repetition."\n", " ".$repetition."\n", $str);
			if(strpos($str, $repetition." ".$preposition." ".$repetition) == 0){
				$str = str_replace($repetition." ".$preposition." ".$repetition." ", $repetition." ", $str);
				$str = str_replace($repetition." ".$preposition." ".$repetition."\n", $repetition."\n", $str);
			}
	}
	return $str;
}

function get_repetitions($str){
	$found = str_word_count($str,1);
	//get all words with occurance of more then 1
	$counts = array_count_values($found);
	$repeated = array_keys(array_filter($counts,function($a){return $a > 1;}));
	//begin results with the groups of 1 word.
	$results = $repeated;
	while($word = array_shift($found)){
		if(!in_array($word,$repeated)) continue;
		$additions = array();
		while($add = array_shift($found)){
			if(!in_array($add,$repeated)) break;
			$additions[] = $add;
			$count = preg_match_all('/'.preg_quote($word).'\W+'.implode('\W+',$additions).'/si',$str,$matches);
			if($count > 1){
				$newmatch = $word.' '.implode(' ',$additions);
				if(!in_array($newmatch,$results)) $results[] = $newmatch;
			} else {
				break;
			}
		}
		if(!empty($additions)) array_splice($found,0,0,$additions);
	}
	foreach($results as $key => $result){
		if(strpos($str, $result." ".$result) === false && strpos($str, $result." of the ".$result) === false && strpos($str, $result." of ".$result) === false){
			unset($results[$key]);
		}
	}
	return $results;
}