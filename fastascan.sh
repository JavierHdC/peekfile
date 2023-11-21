#!/bin/bash
#Check if the directory input is correct.
if [[ -d $1 && $2 =~ ^[0-9]+$ ]]; then 
#Create a command to find .fasta/.fa files in our current directory and its subfolders.
N_files=$(find $1 -type f -name "*.fa" -or -name "*.fasta" | wc -l)
echo "There are $N_files .fa/.fasta files in your current folder and its subfolders"

#Create a command to count how many unique ID´s the .fasta/.fa files contain in total.
#Create a temporal variable to store all ID´s.
ID=$(mktemp)
#Find all ID´s by using grep ">" (">" is the first character in all ID´s) and store them in the previous variable.
for i in $(find $1 -type f -name "*.fa" -or -name "*.fasta"); do grep ">" $i >> $ID
#Count all the unique ID´s stored in the variable.
total_ID=$(sort $ID | uniq | wc -l)
done
echo "Total unique fasta/fa ID´s: $total_ID"

#Start the report.
for i in $(find $1 -type f -name "*.fa" -or -name "*.fasta"); do
file_name=$(basename $i); folder_name=$(dirname $i);
#Nice header including the filename. It was added its folder in a separated line.
echo  "--====="$file_name" report=====--";
echo "It is located in the folder:" $folder_name;
#Check is it is a proteoin file or a nucleotide file.
if [[ $(awk '!/>/ && /[DEFHIKLMPQRSVWY]/{found=1} END{print found}' "$i") == 1 ]];
then echo "It is a protein file";
else echo "It is a nucleotide file";
fi;
#Count how many sequences there are inside. 
echo "There are" $(grep -c ">" $i) "sequence(s)."
#Check if it is a symbolic link or not.
if [[ -h $i ]];
then echo "It is a symbolic link";
else echo "It is not a symbolic link";
fi;
#Total sequence length in each file (no spaces " ", gaps "-" and no new line characters)
echo "The length of the full sequence is:" $(awk '!/>/ {gsub(/[ -]/, ""); count += length($0)} END {print count}' "$i")
#Check How many lines should be printed basing on the argument 2. 
if [[ $2 -gt 0 ]];
then if [[ $(cat $i | wc -l) -le $((2*$2)) ]];
then cat $i;
else head -n $2 $i;
echo "..."; tail -n $2 $i;
fi;
fi;
done

#Require a proper second argument.
elif ! [[ $2 =~ ^[0-9]+$ ]] && [[ -d $1 ]]; then echo "Please select a number of lines as the second argument.";
#Requiere a proper first argument.
elif ! [[ -d $1 ]] && [[ $2 =~ ^[0-9]$ ]]; then echo "Please select a valid directory as the first argument.";
#Requiere both arguments to be proper.
else echo "Please select a valid directory as the first argument and a number of lines as the second argument."; 
fi
