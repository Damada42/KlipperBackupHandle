#!/bin/bash
filename=""
variablefilename="$HOME/backupinfo.ini"
modenas()
{
  if [ -z "$filename" ]; then
    rm -rv $nasbackupfolder/klipper_config 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
    sleep 1s ;
    cp -rpv $HOME/klipper_config/ $nasbackupfolder/klipper_config 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
    echo "NAS folder backup"
  else
    cp -rpv $DIRstartscript/$filename $nasbackupfolder 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
    echo "NAS zip backup"
  fi
}
modeusb()
{
  if [ -z "$filename" ]; then
    rm -rfv $usbbackupfolder/klipper_config 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
    sleep 1s
    cp -rpv $HOME/klipper_config/ $usbbackupfolder/klipper_config 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
    echo "USB folder backup"
  else
    cp -rpv $DIRstartscript/$filename $usbbackupfolder 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log

    echo "USB zip backup"
  fi
}
if [ -z "$(sed -nr "/^\[variables\]/ { :l /^usbbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)" ] || [ -z "$(sed -nr "/^\[variables\]/ { :l /^logfilesbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)" ] || [ -z "$(sed -nr "/^\[variables\]/ { :l /^nasbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)" ]; then
  echo "Backup abourt because path values not ins 'backupinfo.ini' File."
elif [  -z "$(sed -nr "/^\[variables\]/ { :l /^backuphandlefolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)" ]; then
  echo "STOPPING BACKUP because no 'backuphandlefolder' in file 'backupinfo.ini'!!! Please insert manuel!! "
else
  DIRstartscript=$(sed -nr "/^\[variables\]/ { :l /^backuphandlefolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)
  usbbackupfolder=$(sed -nr "/^\[variables\]/ { :l /^usbbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)
  nasbackupfolder=$(sed -nr "/^\[variables\]/ { :l /^nasbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)
  logfilesbackupfolder=$(sed -nr "/^\[variables\]/ { :l /^logfilesbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)
  savemode=$(echo "$(sed -nr "/^\[variables\]/ { :l /^save_mode[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)" | sed 's/./\L&/g')
  cd $DIRstartscript
  echo "$PWD"
  echo "`date -u`" >> $logfilesbackupfolder/log_ready.log
  echo "`date -u`" >> $logfilesbackupfolder/log_fail.log
  if [ -z "$2" ] && [ ! -z "$1" ]; then
#    echo "ONLY INPUT1"
    if [ "$1" = "nas" ] || [ "$1" = "usb" ] || [ "$1" = "both" ]; then
#      echo "ONLY savemode"
      savemode=$1
    else
      filename=$1
    fi
  elif [ ! -z "$2" ] && [ ! -z "$1" ]; then
#    echo "INPUT1 and INPUT2"
    filename=$2
    if [ "$1" = "nas" ] || [ "$1" = "usb" ] || [ "$1" = "both" ]; then
#      echo "both inputs an right savemode"
      savemode=$1
    fi
  fi
  case $savemode in
    nas)
      modenas
      ;;
    usb)
      modeusb
      ;;
    both)
      modenas
      modeusb
      ;;
  esac
  echo "$(tail -65 $logfilesbackupfolder/log_ready.log)" > $logfilesbackupfolder/log_ready.log
  echo "$(tail -65 $logfilesbackupfolder/log_fail.log)" > $logfilesbackupfolder/log_fail.log
fi