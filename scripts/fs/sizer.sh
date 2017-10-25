#!/bin/bash

DAYS=90
source_path=$1
total_count=0

CLEAR="\e[0m"
action="\e[38;5;184m"
warning="\e[38;5;196m"
caption="\e[38;5;77m"

for entry in $(find $source_path -type f); do
    size=`du -sh $entry`
    ((total_count++))
    echo -e "$action The size of file is:$caption $size"
done

echo -e "$CLEAR"

echo -e "Total files in system: $total_count\n"
