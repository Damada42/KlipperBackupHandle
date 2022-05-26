#!/bin/bash
backuphandlefolder="$HOME/klipper_config/backuphandle"
usbbackupfolder="/media/usbstickdata"
nasbackupfolder="$HOME/shares/klipperbackup"
logfilesbackupfolder="$HOME/klipper_config/Backuplogs"
variablefilename="$HOME/backupinfo.ini"
echo "########################################################################"
echo "Please enter working path for backuphandlefolder to create in '$HOME/klipper_config' path: "
echo "If it is empty it use the default path 'backuphandle'. "
read inputworking

if [ ! -z "$inputworking" ] ; then
    backuphandlefolder=$HOME/klipper_config/$inputworking
fi
echo "The working path are: $backuphandlefolder"
mkdir $backuphandlefolder  >/dev/null 2>&1
echo "########################################################################"
echo "Please enter USB path to creat it in 'media' folder: "
echo "If it is empty it use the default path 'usbstickdata'. "
read inputusb
if [ ! -z "$inputusb" ] ; then
    usbbackupfolder=/media/$inputusb
fi
echo "The USB path are: $usbbackupfolder"
sudo mkdir $usbbackupfolder  #>/dev/null 2>&1

echo "########################################################################"
echo "Please enter NAS path to creat it in '$HOME/shares' folder: "
echo "If it is empty it use the default path 'klipperbackup'. "
read inputnas
if [ ! -z "$inputnas" ] ; then
    nasbackupfolder=$HOME/shares/$inputnas
fi
echo "The NAS path are: $nasbackupfolder"
mkdir $HOME/shares >/dev/null 2>&1
mkdir $nasbackupfolder >/dev/null 2>&1

echo "########################################################################"
echo "Please enter Logfile path to creat it in '$HOME/klipper_config' folder: "
echo "If it is empty it use the default path 'Backuplogs'. "
read inputlogfiles
if [ ! -z "$inputnas" ] ; then
    logfilesbackupfolder=$HOME/klipper_config/$inputlogfiles
fi
echo "The NAS path are: $logfilesbackupfolder"
mkdir $logfilesbackupfolder >/dev/null 2>&1
touch $logfilesbackupfolder/log_ready.log >/dev/null 2>&1
touch $logfilesbackupfolder/log_fail.log >/dev/null 2>&1

echo "########################################################################"
echo "#######  now it run the rest from the instalation please wait!  ########"
echo "########################################################################"
sudo apt-get -qq install jq -y && sudo apt -qq install zip -y >/dev/null 2>&1
cd $backuphandlefolder
wget https://raw.githubusercontent.com/Damada42/KlipperBackupHandle/main/handlebackup.sh >/dev/null 2>&1
wget https://raw.githubusercontent.com/Damada42/KlipperBackupHandle/main/Backup.sh >/dev/null 2>&1

if [ ! -e $variablefilename ]; then
  touch $variablefilename
  echo "[variables]">> $variablefilename
  echo "backuphandlefolder = $backuphandlefolder">> $variablefilename
  echo "usbbackupfolder = $usbbackupfolder">> $variablefilename
  echo "nasbackupfolder = $nasbackupfolder">> $variablefilename
  echo "logfilesbackupfolder = $logfilesbackupfolder">> $variablefilename
fi

