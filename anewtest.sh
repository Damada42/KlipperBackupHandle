#!/bin/sh
#sudo apt-get install jq -y

#System variable
SN="$(tr -d '\0' < /sys/firmware/devicetree/base/serial-number)"

responsedata=$(curl -s 'http://192.168.1.41/printer/objects/query?print_stats=state'  | jq -r '.result.status.print_stats.state')
#echo "$responsedata"
if [ -z "$responsedata" ]; then
  echo "!!!!No state from printer OR no connection to moonraker !!!!!"
else
  if ! [ $responsedata = "standby" ]; then
    echo "Backup about because printer running"
    export BackupKlipperTrigger="1"
  else
    if  [ -z "${BackupKlipperTrigger}" ] || [ "${BackupKlipperTrigger}" = "0" ]; then
      echo "makeing backup"
      #start BACKUP Script
      bash backup.sh
      export BackupKlipperTrigger="0"
    elif [ "${BackupKlipperTrigger}" = "1" ]; then
      echo "makeing backup ENV Variable are true"
      #start BACKUP Script
      bash backup.sh
      export BackupKlipperTrigger="0"
    else
      echo "no backup needed!"
    fi
  fi
fi