#!/usr/local/bin/bash

CLEAR="\e[0m"
GREEN="\e[38;5;118m"
RED="\e[38;5;196m"
YELLOW="\e[38;5;226m"
process_nanme=index.pl

array=( $(ps aux | grep $process_name | grep -v "grep" | awk '{print $2}') )

if [[ $1 == "-h" || $1 == "" || $1 == "--help" ]]; then
echo "usage: ./killotrs.sh [-hlk]"
echo -e "\t -h or --help: Show this message"
echo -e "\t -l or --list: Show list of stucked processes"
echo -e "\t -k or --kill: kill all stucked processes"
exit 0;
fi

if [[ $1 == "-l" || $1 == "--list" ]]; then
    if [[ ${array[@]} ]]; then
       echo -e "$GREEN Stucked processes PIDs $RED${array[@]} $CLEAR";
    else
       echo -e "$YELLOW No such proccesses found $CLEAR"
    fi
exit 0;
fi

if [[ $1 == "-k" || $1 == "--kill" ]]; then
if [[ ${array[@]} ]]; then
   echo -e "$YELLOW Found proccesses $RED ${array[@]}"
else
   echo -e "$YELLOW No such proccesses found, nothing to kill $CLEAR"
fi
for i in "${array[@]}"; do
   echo -e "$GREEN Trying to kill $RED $i" $CLEAR;
   kill $i;
   if [[ ${array[@]} ]]; then
      echo "`date +%d.%m.%y` - `date +%H:%M:%S` >  kill $i" >> /var/log/killotrs.log
   fi
done
fi

