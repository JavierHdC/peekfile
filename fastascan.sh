#!/bin/bash

#Bash script whose purpose is to produce a concise report about the fasta/fa files in a given folder and its subfolders at any depth.
#The script takes 2 optional arguments:
	#1.The folder X where to search the files (default: current folder).
	#2.A number of lines N (default: 0).

#Set default values if no arguments are provided.
dir=${1:-.}
lines=${2:-0}

#Check if the directory input is correct and the second argument is a number.
if [[ -d $dir && $lines =~ ^[0-9]+$ ]]
	then
	echo "===============================================================" 
	echo "Generating a report for the .fasta and .fa files in directory $dir, displaying the full content of files with less than $((2*$lines)) lines, or showing the $lines first and last lines of the larger files..."
	echo "==============================================================="

	#Create a command to find .fasta/.fa files in our current directory and its subfolders.
	echo "There are $(find $dir -type f -name "*.fa" -or -name "*.fasta" | wc -l) .fa/.fasta files in the folder and its subfolders."

	#Create a command to count how many unique ID´s the .fasta/.fa files contain in total.
	#Create a temporal variable to store all ID´s.
	ID=$(mktemp)
	#Find all ID´s and store them in the previous variable.
	for i in $(find $dir -type f -name "*.fa" -or -name "*.fasta")
		do grep ">" $i >> $ID
	done
	#Count all the unique ID´s stored in the variable.
        total_ID=$(sort $ID | uniq | wc -l)	
	echo "Total unique fasta/fa ID´s: $total_ID "

	#Start the report.
	for i in $(find $dir -type f -name "*.fa" -or -name "*.fasta"); do
		#Check if it is a protein file or a nucleotide file and include it in the header with filename.
                if [[ $(awk '!/>/ && /[DEFHIKLMPQRSVWY]/{found=1} END{print found}' "$i") == 1 ]]
                        then echo  "---====="$i" Protein file report=====---" 
                        else echo  "---====="$i" Nucleotide file report=====---" 
		fi

		#Count how many sequences there are inside. 
		echo "There are $(grep -c ">" $i) sequence(s) inside."
		#Check if it is a symbolic link or not.
		if [[ -h $i ]]
			then echo "The file is a symbolic link."
			else echo "The file is not a symbolic link."
		fi

		#Total sequence length in each file (no spaces " ", gaps "-" and no new line characters)
		echo "The length of the full sequence is:" $(awk '!/>/ {gsub(/[ -]/, ""); count += length($0)} END {print count}' "$i")
		#Check How many lines should be printed basing on the argument 2. 
		if [[ $lines -gt 0 ]]
			then if [[ $(cat $i | wc -l) -le $((2*$lines)) ]]
				then echo "The full content of the file is:" 
				cat $i
				else echo "The first and last $2 lines are:" 
				head -n $lines $i
				echo "..."
				tail -n $lines $i
			fi
		fi
	done

#Require a proper second argument.
elif ! [[ $lines =~ ^[0-9]+$ ]] && [[ -d $dir ]]; then echo "Please select a number of lines as the second argument.";
#Requiere a proper first argument.
elif ! [[ -d $dir ]] && [[ $lines =~ ^[0-9]$ ]]; then echo "Please select a valid directory as the first argument.";
#Requiere both arguments to be proper.
else echo "Please select a valid directory as the first argument and a number of lines as the second argument."; 
fi
