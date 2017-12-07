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

grep -v -x -F -f $1.equal.txt $1 > $1.c
grep -v -x -F -f $1.equal.txt $2 > $2.c

# But this is crazily slow!! Better use MP's FilterTestDataFromTrainingData.exe (needs sudo apt-get -qq -y install mono-complete)
#
# 	mono --runtime=v4.0 FilterTestDataFromTrainingData.exe \
#		-P filename.en.equal.txt filename.en.equal.txt filename.en.equal.txt filename.en.equal.txt \
#		filename.en filename.de filename.en.c filename.de.c