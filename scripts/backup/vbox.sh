#!/bin/bash

VMNAME=$1
BACKUPDIR=/srv/backup
STATE=`sudo -uvbox vboxmanage showvminfo $VMNAME | grep State | awk '{ print $2 }'`
check_dev=`sudo -uvbox vboxmanage showvminfo $VMNAME | grep UUID | grep IDE`
if [ -z "$check_dev" ]; then
    SOURCE=`sudo -uvbox vboxmanage showvminfo $VMNAME | grep SATA | grep -v "Empty" | grep -v "Storage"  | awk '{ print $4 }'`
else
    SOURCE=`sudo -uvbox vboxmanage showvminfo $VMNAME | grep IDE | grep -v "Empty" | grep -v "Storage"  | awk '{ print $4 }'`
fi
exp=`basename $SOURCE | sed "s/[^.]*.//"`
mails=( admin@optimistks.com.ua support@itsource.com.ua)
DAYS=1

function high_alert_mail {
  vms_list=`ls $BACKUPDIR`
  size=`for vm in ${vms_list[@]}; do du -h $BACKUPDIR/$vm | awk '{ print $1}'; done`
  count=`for vm in ${vms_list[@]}; do ls $BACKUPDIR/$vm | wc -l; done`
  echo -e "VM's Backup:"
  echo "╔════════════╦═════════╦══════════╗"
  printf "║ %10s ║ %7s ║ %8s ║\n" "VM name" "count" "Size"
  echo "╠════════════╬═════════╬══════════╣"
   for vm in ${vms_list[@]}; do
     size=`du -h $BACKUPDIR/$vm | awk '{ print $1}'`
     count=`ls $BACKUPDIR/$vm | wc -l`
     printf "║ %10s ║ %7s ║ %8s ║\n" "$vm" "$count" "$size"
   done
  echo "╚════════════╩═════════╩══════════╝"
}

while [[ $STATE == "running" ]]
  do
    sudo -uvbox vboxmanage controlvm $VMNAME savestate
    sleep 30
    STATE=`sudo -uvbox vboxmanage showvminfo $VMNAME | grep State | awk '{ print $2 }'`
done

if ! [ -d $BACKUPDIR/$VMNAME ]; then
    mkdir -p $BACKUPDIR/$VMNAME
fi

error="`cp -f $SOURCE $BACKUPDIR/$VMNAME/$VMNAME-\`date +%d.%m.%y\`.$exp 2>&1`"
get_error=$?

#find $BACKUPDIR/$VMNAME/ -type f -mtime +$DAYS -print0 | xargs -0 rm -f

for email in ${mails[@]}; do
  if [[ "$get_error" == "0" ]]; then
    high_alert_mail | mail -s "Optimistks $VMNAME backup is OK" "$email"
  else
    echo -e "Backup failure with error: $error" | mail -s "Optimistks $VMNAME backup error" "$email"
  fi
done
sudo -uvbox vboxmanage startvm $VMNAME --type headless
