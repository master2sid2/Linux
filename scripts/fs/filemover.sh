#!/bin/bash

DAYS=90
source_path=/home
dest_path=/root
total_count=0

CLEAR="\e[0m"
action="\e[38;5;184m"
warning="\e[38;5;196m"
caption="\e[38;5;77m"

for entry in $(find $source_path -type f -mtime +$DAYS -print0 | xargs -0 ls ); do

#list=`find /var/vmail/ -type f -mtime +$DAYS -print0 | xargs -0 ls | grep "mailer.mobrider.com"`
   create_dir=`dirname $entry`

   if ! [ -d $dest_path$create_dir ]; then
      echo -e "$warning The directory$caption $dest_path$create_dir$warning doesnt exist, creating...."
#      mkdir -p $dest_path$create_dir
      echo -e "$action Moving files from$caption $entry$action to$caption $dest_path$create_dir"
#      mv $entry $dest_path$create_dir
      ((total_count++))
   else
      echo -e "$action Moving files from$caption $entry$action to$caption $dest_path$create_dir"
#      mv $entry $dest_path$create_dir
      ((total_count++))
   fi
done

echo -e "$CLEAR"

echo -e "Total files moved: $total_count\n"
