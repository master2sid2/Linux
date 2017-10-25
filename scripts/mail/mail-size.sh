#!/bin/bash
#
# For Linux system use !/bin/bash
#

clear="\e[39m"
backgroundred="\e[41m"
green="\e[92m"
yellow="\e[93m"
orange="\e[38;5;202m"
blue="\e[38;5;117m"
message="Newlogic mail server disk capacity"
emails=(v.khutornyy@itsource.com.ua)
path="/home"

function calculate {

array=( $(ls $path | grep -v ".py") )

echo -e $backgroundred"E-mail user" $'\t' "message count" "\e[49m"
echo  ""
for rec in ${array[@]}; do
        mail_count=($(find $path/$rec -type f | wc -l))
        size_in_byte=($(du -s $path/$rec | awk '{ print $1 }'))
        size_per_user=($(du -sh $path/$rec))
        total_mail_count=$(($total_mail_count+$mail_count))
        total_size=$(($total_size+$size_in_byte))
        printf "$green%-15s $yellow%-s $orange%-7d $blue%-s\n$clear" "$rec" "count =" "$mail_count" "Size = $size_per_user"
done

printf "$green%-15s $yellow%-7s $orange%-7d $blue%s\n$clear" "  " "  " "$total_mail_count" "Total = $((($total_size/1024)/1024))G ($(($total_size/1024)) MB)"

}

if [[ $1 == "-s" || $1 == "--send" ]]; then
	calculate | mail -s "$message" "$emails"
exit 0;
fi

calculate
