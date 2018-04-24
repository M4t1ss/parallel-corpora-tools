<?php

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];

//Open files
$inSRC = fopen($source_sentences, "r") or die("Can't open input file!");
$inTRG = fopen($target_sentences, "r") or die("Can't open input file!");

$outSRC = fopen($source_sentences.".reptok", "w") or die("Can't create output file!");
$outTRG = fopen($target_sentences.".reptok", "w") or die("Can't create output file!");

$outSRC_rem = fopen(str_replace("/output","/output/removed",$source_sentences).".reptok", "w") or die("Can't create removed source output file!");
$outTRG_rem = fopen(str_replace("/output","/output/removed",$target_sentences).".reptok", "w") or die("Can't create removed target output file!");

$i = 0;
while (($sourceSentence = fgets($inSRC)) !== false && ($targetSentence = fgets($inTRG)) !== false) {
	$repSrc = replace_repetitions($sourceSentence);
	$repTrg = replace_repetitions($targetSentence);
	
    if($repSrc==$sourceSentence & $repTrg==$targetSentence){
        fwrite($outSRC, $sourceSentence);
        fwrite($outTRG, $targetSentence);
    }else{
        fwrite($outSRC_rem, $sourceSentence);
        fwrite($outTRG_rem, $targetSentence);
		$i++;
	}
}

echo "Removed ".$i." sentence pairs with repeating tokens\n";



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