#!/bin/bash
#sudo apt-get install jq -y
devicepathusb="/media/timeusb/Backup"
devicepathnas="$HOME/shares/klipper/Backup"
devicepathlogfiles="$HOME/klipper_config/Backuplogs"
filename='backupvariables.ini'
imputprintername=""
echo "$devicepathlogfiles/log_ready.log"
echo "$devicepathnas/klipper_config"
echo "$devicepathusb/klipper_config"
now=`date +"%Y%m%d_%H%M_"`
targetname="${now}BackupKlipper${imputprintername}.zip"
echo $targetname

if [ ! -e $filename ]; then
  touch $filename
  echo "[variables]">> $filename
  echo "BackupAfterPrint = 0">> $filename
  echo "Targetfilename = $targetname">> $filename
fi