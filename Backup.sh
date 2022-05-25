#!/bin/bash
backupmode="nas"
filename=""
inifilename='backupvariables.ini'
DIRsource="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIRsource
if [ -z "$(sed -nr "/^\[variables\]/ { :l /^usbbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $inifilename)" ] || [ -z "$(sed -nr "/^\[variables\]/ { :l /^logfilesbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $inifilename)" ] || [ -z "$(sed -nr "/^\[variables\]/ { :l /^nasbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $inifilename)" ]; then
  echo "Backup abourt because path value not ins ini File."
else
  echo "RUUUUUUN BABY!!!!!!"
  usbbackupfolder=$(sed -nr "/^\[variables\]/ { :l /^usbbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $inifilename)
  nasbackupfolder=$(sed -nr "/^\[variables\]/ { :l /^nasbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $inifilename)
  logfilesbackupfolder=$(sed -nr "/^\[variables\]/ { :l /^logfilesbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $inifilename)
  echo "`date -u`" >> $logfilesbackupfolder/log_ready.log
  echo "`date -u`" >> $logfilesbackupfolder/log_fail.log
  if [ -z "$2" ] && [ ! -z "$1" ]; then
    echo "ONLY INPUT1"
    if [ "$1" = "nas" ] || [ "$1" = "usb" ]; then
      echo "ONLY backupmode"
      backupmode=$1
    else
      filename=$1
    fi
  elif [ ! -z "$2" ] && [ ! -z "$1" ]; then
    echo "INPUT1 and INPUT2"
    filename=$2
    if [ "$1" = "nas" ] || [ "$1" = "usb" ]; then
      echo "both inputs an right backupmode"
      backupmode=$1
    fi
  fi
  if [ "$backupmode" = "nas" ]; then
    if [ -z "$filename" ]; then
      #rm -rv $nasbackupfolder/klipper_config 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
      #sleep 1s ;
      #cp -rpv $HOME/klipper_config/ $nasbackupfolder/klipper_config 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
      echo "NAS folder backup"
    else
      #cp -rpv $DIRsource/$filename $nasbackupfolder 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
      echo "NAS zip backup"
    fi
  else
    if [ -z "$filename" ]; then
      #rm -rv $usbbackupfolder/klipper_config 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
      #sleep 1s
      #cp -rpv $HOME/klipper_config/ $usbbackupfolder/klipper_config 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
      echo "USB folder backup"
    else
      #cp -rpv $DIRsource/$filename $usbbackupfolder 1>> $logfilesbackupfolder/log_ready.log 2>> $logfilesbackupfolder/log_fail.log
      echo "USB zip backup"
    fi
  fi
  echo "$(tail -65 $logfilesbackupfolder/log_ready.log)" > $logfilesbackupfolder/log_ready.log
  echo "$(tail -65 $logfilesbackupfolder/log_fail.log)" > $logfilesbackupfolder/log_fail.log
fi