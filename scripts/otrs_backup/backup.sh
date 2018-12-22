#/bin/bash
#
# This script is writing to use in BSD system
#

EMAIL=""

function writeLog () {
echo -e "`date -j +"%d-%m-%Y %H:%M"` \t $1" >> /var/log/otrs_backup.log
}

state=""
cur_date=`date -j +"%d-%m-%Y"`

# Archivating otrs directory
writeLog "Starting backup"
mkdir /backup/$cur_date
writeLog "Dir /backup/$cur_date created"

startcopytimeshtamp=`date +%s`
file_copy=`/usr/bin/tar -cvf /backup/$cur_date/otrs.tar.gz /usr/local/otrs/`

if [[ $? == "0" ]]; then
        state="$state File copy complete successfully.\n"
        writeLog "File copy was complete successfully"
else
        state="$state File copy state error.\n $file_copy"
        writeLog "File copy error"
fi
copyendtimeshtamp=`date +%s`
sleep 5

# Dumping otrs databases
writeLog "Database dumping started"
dumpstarttimeshtamp=`date +%s`
db_copy=`/usr/local/bin/mysqldump --max-allowed-packet=204800M -A > /backup/$cur_date/full-mysqldump.sql`

if [[ $? == "0" ]]; then
        state="$state Dump DB was complete successfully.\n"
        writeLog "Database dump complete successfully"
else
        state="$state Dump DB state error.\n $db_copy"
        writeLog "Database dump error"
fi
enddumptimeshtamp=`date +%s`

writeLog "Backup of OTRS is finish"

result=$(( ($copyendtimeshtamp - $startcopytimeshtamp) / 60 ))
writeLog "File copy was finished in $result minuts"
result=$(( ($enddumptimeshtamp - $dumpstarttimeshtamp) / 60 ))
writeLog "Dumping of database was finished in $result minuts"

echo -e $state | mail -s "OTRS backup" "$EMAIL"

umount /backup/
