#!/bin/bash
#Check if the directory input is correct.
if [[ -d $1 ]]; then 
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
echo "Total unique fasta/fa ID´s: $total_ID"
done
#Start the report.
for i in $(find $1 -type f -name "*.fa" -or -name "*.fasta");
do file_name=$(basename $i) 
echo  "--====="$file_name" report=====--"
#Check if it is a symbolic link or not.
if [[ -h $i ]]; then echo "It is a symbolic link"; else echo "It is not a symbolic link"; fi
done

else echo "Please select a valid directory as the first argument"
fi
