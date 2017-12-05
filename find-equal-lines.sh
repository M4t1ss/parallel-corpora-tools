#/bin/bash
# Parameters - parallel file names
#	filename.en
#	filename.de
# Outputs - equal lines found in both files and cleaned parallel files
#	filename.en.equal.txt
#	filename.en.c
#	filename.de.c

sort $1 > $1.s
sort $2 > $2.s

comm -12 $1.s $2.s > $1.equal.txt

rm $1.s
rm $2.s

# Now we can remove the equal lines from the original parallel files
# But this is crazily slow!! Better use MP's FilterTestDataFromTrainingData.exe
grep -v -x -F -f $1.equal.txt $1 > $1.c
grep -v -x -F -f $1.equal.txt $2 > $2.c