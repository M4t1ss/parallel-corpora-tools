<?php
error_reporting(E_ALL ^ E_WARNING);
ini_set("memory_limit","8096M");

use \parallel\{Runtime, Future, Channel, Events};

//Input parameters
$source_sentences 	= $argv[1];
$target_sentences	= $argv[2];
$bad_sentence_num 	= $argv[3];

//Open files
$outSRC = fopen($source_sentences.".glp", "a") or die("Can't create source output file!");
$outTRG = fopen($target_sentences.".glp", "a") or die("Can't create target output file!");

$outSRC_rem = fopen(str_replace("/output","/output/removed",$source_sentences).".glp", "a") or die("Can't create removed source output file!");
$outTRG_rem = fopen(str_replace("/output","/output/removed",$target_sentences).".glp", "a") or die("Can't create removed target output file!");

$badLineNumbers = file($bad_sentence_num);
$sources 		= file($source_sentences);
$targets 		= file($target_sentences);

$max_key = max(array_keys($sources));

$cores = 16;


$lines = count($sources); 
$lines_per_core = ceil($lines / $cores);

$big_bad_numbers = array();
$number_array = array();


$prevSlot = 0;
foreach($badLineNumbers as &$badLineNumber) {
    $badLineNumber = trim($badLineNumber)-1;
	
	$currentSlot = floor($badLineNumber / $lines_per_core);
	if($currentSlot > $prevSlot){
		for($f = $prevSlot; $f < $currentSlot; $f++){
			$big_bad_numbers[] = $number_array;
			$number_array = array();
		}
	}
	$prevSlot = $currentSlot;
	
	$number_array[] = $badLineNumber;
}

if($prevSlot < $cores){
	for($f = $prevSlot; $f < $cores; $f++){
		$big_bad_numbers[] = $number_array;
		$number_array = array();
	}
}


$thread_function = function ($c, $start_line, $lines_per_core, $sources, $targets, $outSRC, $outTRG, $outSRC_rem, $outTRG_rem, $max_key, $big_bad_numbers) {
	
	if($start_line > $max_key){
		echo "I have gone too far...\n";
	}else{		
		$outSRCs = fopen("php://fd/{$outSRC}", 'a');
		$outTRGs = fopen("php://fd/{$outTRG}", 'a');
		$outSRC_rems = fopen("php://fd/{$outSRC_rem}", 'a');
		$outTRG_rems = fopen("php://fd/{$outTRG_rem}", 'a');
		$removed = 0;

		$SRCs = "";
		$TRGs = "";
		$rSRCs = "";
		$rTRGs = "";
		for ($j = $start_line; $j < $start_line + $lines_per_core; $j++){
			//process line $j
			if($j <= $max_key){
				if(!in_array($j, $big_bad_numbers[$c])){
					fwrite($outSRCs, $sources[$j]);
					fwrite($outTRGs, $targets[$j]);
				}else{
					$removed++;
					fwrite($outSRC_rems, $sources[$j]);
					fwrite($outTRG_rems, $targets[$j]);
				}
			}
		}
		echo "Removed ".$removed." sentence pairs with a mismatch between specified and identified language\n";

	}
};

\parallel\run($thread_function, array(0, 0, $lines_per_core, $sources, $targets, $outSRC, $outTRG, $outSRC_rem, $outTRG_rem, $max_key, $big_bad_numbers));
for($c = 1; $c < $cores; $c++){
	//process lines from $c * $lines_per_core to $c+1 * $lines_per_core
	//this should already be done in parallel...
	
	$start_line = $c * $lines_per_core;
	
	\parallel\run($thread_function, array($c, $start_line, $lines_per_core, $sources, $targets, $outSRC, $outTRG, $outSRC_rem, $outTRG_rem, $max_key, $big_bad_numbers));
}


function get_cpu_core_count() {
    $command = "cat /proc/cpuinfo | grep processor | wc -l";

    return  (int) shell_exec($command);
}
