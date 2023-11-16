#!/bin/bash
#Create a command to find .fasta/.fa files in our current directory and its subfolders. 
N_files=$(find . -type f -name "*.fa" -or -name "*.fasta" | wc -l)
echo "There are $N_files .fa/.fasta files in your current folder and its subfolders"

#Create a command to count how many unique ID´s the .fasta/.fa files contain in total.
#Create a temporal variable to store all ID´s.
ID=$(mktemp)
#Find all ID´s by using grep ">" (">" is the first character in all ID´s) and store them in the previous variable.
for i in $(find . -type f -name "*.fa" -or -name "*.fasta"); do grep ">" $i >> $ID
done
#Count all the unique ID´s stored in the variable. 
total_ID=$(sort $ID | uniq | wc -l)
echo "Total unique fasta/fa ID´s: $total_ID"
#Delete the temporal variable
rm $ID
