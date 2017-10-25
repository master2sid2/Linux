#!/bin/sh

#########################################################
#                                                       #
#               QEMU KVM backup script                  #
#               Author: Vitaliy Kkhutornyy              #
#                                                       #
#########################################################
NAME=`date +%d.%m.%y`;
VMNAME=$1
#BACKUPDIR="~/"
BACKUPDIR=/vms-storage/gf_backup
BACKUPPATH=$BACKUPDIR/$VMNAME/$NAME
VMPATH=$BACKUPDIR/$VMNAME
SERVERNAME=46.231.226.70
DAYS=1
STATE=работает
#STATE=приостановлен
SIZE=0
FREE=`df | grep /vms | awk '{ print $4 }'`

for disk_images in `virsh -c qemu:///system domblklist $VMNAME | awk  '{ if (NR >= 2) print $2}' |  sed 's,^-,,g' | grep -v "^$"`
do
        SIZE=$(($SIZE+`du $disk_images | awk '{ print $1 }'`))
done

GSIZE=$(($SIZE/(1024*1024)))
GFREE=$(($FREE/(1024*1024)))

if [ "$SIZE" -gt "$FREE" ]; then
        echo "Не достаточно свободного места на диске. Необходимо $GSIZE GB, свободно $GFREE GB." | mail -s "KVM Backup error $VMNAME" "support@itsource.com.ua"
        exit 0;
fi

STR=`virsh -c qemu:///system list | grep $VMNAME | awk '{print $2}'`

    while [[ $STATE == `virsh -c qemu:///system list | grep $VMNAME | awk '{print $3}'` ]]
     do
        echo "VM is curently running, try to shutdown $VMNAME"
        virsh -c qemu:///system shutdown $VMNAME
        sleep 30s

     done
STR=`virsh -c qemu:///system list | grep $VMNAME | awk '{print $2}'`

if [[ "$STR" != "$VMNAME" ]]; then
    echo "Start backup"
    #ssh -p 2222 backuper@$SERVERNAME mkdir -p $BACKUPPATH
        mkdir -p $BACKUPPATH
    for disk_images in `virsh -c qemu:///system domblklist $VMNAME | awk  '{ if (NR >= 2) print $2}' |  sed 's,^-,,g' | grep -v "^$"`
        do
           #scp -P 2222 $disk_images backuper@$SERVERNAME:$BACKUPPATH
           cp $disk_images $BACKUPPATH
        done
    echo "Backup finish, starting up $VMNAME"
    echo "Резервное копирование $VMNAME прошло успешно" | mail -s "$VMNAME backup OK" "support@itsource.com.ua"
    virsh -c qemu:///system start $VMNAME
else
    echo "VM alrady running. Cannot continue"
fi

#ssh -p 2222 backuper@$SERVERNAME find $VMPATH -type d -mtime +$DAYS -print0 | xargs -0 rm -Rf
find $VMPATH -type d -mtime +$DAYS -print0 | xargs -0 rm -Rf
