#!/bin/sh
#########################################################
#                                                       #
#               QEMU KVM backup script                  #
#               Author: Vitaliy Kkhutornyy              #
#                                                       #
#########################################################
NAME=`date +%d.%m.%y -d "yesterday"`;
VMNAME=$1
BACKUPDIR=/vms-storage/gf_backup
MYPATH=$BACKUPDIR/$NAME
DAYS=1
STATE=running

STR=`virsh -c qemu:///system list | grep $VMNAME | awk '{print $2}'`

if [[ "$STR" == "$VMNAME" ]];
then
    while [[ $STATE == `virsh -c qemu:///system list | grep $VMNAME | awk '{print $3}'` ]]
     do
        echo "VM is curently running, try to shutdown $VMNAME"
        virsh -c qemu:///system shutdown $VMNAME
        sleep 30s
     done
else
    echo "Start backup"
    mkdir $MYPATH
    for disk_images in `virsh -c qemu:///system domblklist $VMNAME | awk  '{ if (NR >= 2) print $2}' | grep -v "^$"`
        do
           cp $disk_images $MYPATH
        done
    echo "Backup finish, starting up $VMNAME"
    virsh -c qemu:///system start $VMNAME
fi

find $BACKUPDIR -type d -mtime +$DAYS -print0 | xargs -0 rm -Rf
