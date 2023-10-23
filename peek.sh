#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

if [ ! -f "$input_file" ]; then
    echo "File not found: $input_file"
    exit 1
fi

# Count the total number of lines in the file
line_count=$(wc -l < "$input_file")

if [ "$line_count" -le 6 ]; then
    # If the file has 6 or fewer lines, just print the whole file
    cat "$input_file"
else
    # Print the first 3 lines
    head -n 3 "$input_file"
    # Print the ellipsis line
    echo "..."
    # Print the last 3 lines
    tail -n 3 "$input_file"
fi
