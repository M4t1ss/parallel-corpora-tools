#/bin/bash
# Parameters - parallel file names filename1 and filename2
# Output - equal lines found in both files - filename1.equal.txt

sort $1 > $1.s
sort $2 > $2.s

comm -12 $1.s $2.s > $1.equal.txt

rm $1.s
rm $2.s
