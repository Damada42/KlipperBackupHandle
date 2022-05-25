#!/bin/bash
backupmode="nas"
filename=""
devicepathusb="/media/timeusb/Backup"
devicepathnas="$HOME/shares/klipper/Backup"
devicepathlogfiles="$HOME/klipper_config/Backuplogs"
DIRsource="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIRsource
echo "`date -u`" >> $devicepathlogfiles/log_ready.log
echo "`date -u`" >> $devicepathlogfiles/log_fail.log
if [ -z "$2" ] && [ ! -z "$1" ]; then
  if [ "$1" = "nas" ] || [ "$1" = "usb" ]; then
    backupmode=$1
  fi
elif [ ! -z "$2" ] && [ ! -z "$1" ]; then
  filename=$2
  if [ "$1" = "zip" ] || [ "$1" = "folder" ]; then
    backupmode=$1
  fi
fi
if [ "$backupmode" = "nas" ]; then
  if [ -z "$filename" ]; then
    rm -rv $devicepathnas/klipper_config 1>> $devicepathlogfiles/log_ready.log 2>> $devicepathlogfiles/log_fail.log
    sleep 1s ;
    cp -rpv $HOME/klipper_config/ $devicepathnas/klipper_config 1>> $devicepathlogfiles/log_ready.log 2>> $devicepathlogfiles/log_fail.log
  else
    cp -rpv $DIRsource/$filename $devicepathnas 1>> $devicepathlogfiles/log_ready.log 2>> $devicepathlogfiles/log_fail.log
  fi
else
  if [ -z "$filename" ]; then
    rm -rv $devicepathusb/klipper_config 1>> $devicepathlogfiles/log_ready.log 2>> $devicepathlogfiles/log_fail.log
    sleep 1s
    cp -rpv $HOME/klipper_config/ $devicepathusb/klipper_config 1>> $devicepathlogfiles/log_ready.log 2>> $devicepathlogfiles/log_fail.log
  else
    cp -rpv $DIRsource/$filename $devicepathusb 1>> $devicepathlogfiles/log_ready.log 2>> $devicepathlogfiles/log_fail.log
  fi
fi
echo "$(tail -65 $devicepathlogfiles/log_ready.log)" > $devicepathlogfiles/log_ready.log
echo "$(tail -65 $devicepathlogfiles/log_fail.log)" > $devicepathlogfiles/log_fail.log