#!/bin/bash

if [ -z "$2" ]; then
  num_lines=3
else
  num_lines="$2"
fi

if [ $(wc -l < "$1") -le $((2 * num_lines)) ]; then
  cat "$1"
else
  head -n "$num_lines" "$1"
  echo "..."
  tail -n "$num_lines" "$1"
fi

