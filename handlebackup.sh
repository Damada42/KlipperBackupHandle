#!/bin/bash
#sudo apt-get install jq -y && sudo apt install zip -y
#read serialnumber from pi
#SN="$(tr -d '\0' < /sys/firmware/devicetree/base/serial-number)"
################################################ INFO ################################
# The first paramater (optional) are the backupmode (zip or folder, default is zip).
# The second parameter from sh file are the name from the printer for the Backup (default is empty).

#init custom variable
Backupafterprinting="0"
responsedata="standby"
savemode="usb"
backupmode="zip"
imputprintername=""
filename='backupvariables.ini'

DIRstartscript=$HOME/klipper_config/backuphandle
echo $DIRstartscript
cd $DIRstartscript
if [ -z "$2" ] && [ ! -z "$1" ]; then
  if [ "$1" = "zip" ] || [ "$1" = "folder" ]; then
    backupmode=$1
  else
    imputprintername=$1
  fi
elif [ ! -z "$2" ] && [ ! -z "$1" ]; then
  imputprintername=$2
  if [ "$1" = "zip" ] || [ "$1" = "folder" ]; then
    backupmode=$1
  fi
fi
if [ "$backupmode" = "zip" ]; then
  now=`date +"%Y%m%d_%H%M_"`
  targetname="${now}BackupKlipper${imputprintername}.zip"
  echo $targetname
  zip -r $targetname $HOME/klipper_config/  >/dev/null 2>&1
else
  targetname=""
fi
if [ ! -e $filename ]; then
  touch $filename  >/dev/null 2>&1
  echo "[variables]">> $filename  >/dev/null 2>&1
  echo "BackupAfterPrint = 0">> $filename  >/dev/null 2>&1
  echo "Targetfilename = $targetname">> $filename  >/dev/null 2>&1
else
  if [ -z "$(sed -nr "/^\[variables\]/ { :l /^BackupAfterPrint[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $filename)" ]; then
    touch $filename  >/dev/null 2>&1
    echo "BackupAfterPrint = 0">> $filename  >/dev/null 2>&1
  fi
  Backupafterprinting=$(sed -nr "/^\[variables\]/ { :l /^BackupAfterPrint[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $filename)
fi
if [ ! "$imputprintername" = "" ]; then
  imputprintername="_$imputprintername"
fi
responsedata=$(curl -s 'http://localhost/printer/objects/query?print_stats=state'  | jq -r '.result.status.print_stats.state')  >/dev/null 2>&1
echo "$responsedata"
if [ -z "$responsedata" ]; then
  echo "!!!!No state from printer OR no connection to moonraker !!!!!"
else
  if [ "${responsedata}" = "printing" ]; then
    echo "Backup has been canceled because printer running"
    Backupafterprinting="1"
  else
    if [ "${Backupafterprinting}" = "0" ]; then
      if  [ "${backupmode}" = "zip" ]; then
        echo "makeing zip backup"
      else
        echo "makeing folder backup"
      fi
    else
      echo "makeing zip backup after print is finished"
      targetname=$(sed -nr "/^\[variables\]/ { :l /^Targetfilename[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $filename)
    fi
    Backupafterprinting="0"
    #start BACKUP Script
#    echo "savemode: $savemode"
#    echo "Dateiname: $targetname"
#    echo "bashbefehl: Backup.sh $savemode $targetname"
    bash Backup.sh $savemode $targetname
  fi
fi
if  [ "${backupmode}" = "zip" ]; then
  cd $DIRstartscript
  rm $targetname >/dev/null 2>&1
fi
sed -i -e "/^\[variables\]/,/^\[.*\]/ s|^\(BackupAfterPrint[ \t]*=[ \t]*\).*$|\1$Backupafterprinting|" $filename
sed -i -e "/^\[variables\]/,/^\[.*\]/ s|^\(Targetfilename[ \t]*=[ \t]*\).*$|\1$targetname|" $filename