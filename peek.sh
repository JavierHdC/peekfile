#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <lines_to_display>"
    exit 1
fi

input_file="$1"
lines_to_display="$2"

if [ ! -f "$input_file" ]; then
    echo "File not found: $input_file"
    exit 1
fi

# Check if lines_to_display is a positive integer
if ! [[ "$lines_to_display" =~ ^[0-9]+$ ]]; then
    echo "Invalid value for lines_to_display: $lines_to_display (must be a positive integer)"
    exit 1
fi

# Count the total number of lines in the file
line_count=$(wc -l < "$input_file")

if [ "$line_count" -le "$((2 * lines_to_display))" ]; then
    # If the file has fewer lines than requested, print the whole file
    cat "$input_file"
else
    # Print the first N lines
    head -n "$lines_to_display" "$input_file"
    # Print the ellipsis line
    echo "..."
    # Print the last N lines
    tail -n "$lines_to_display" "$input_file"
fi

