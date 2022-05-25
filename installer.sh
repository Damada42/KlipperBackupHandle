#!/bin/bash
backupfolder="backuphandle"
usbbackupfolder="/media/usbstickdata"
nasbackupfolder="$HOME/shares/klipperbackup"
logfilesbackupfolder="$HOME/klipper_config/Backuplogs"
variablefilename='backupvariables.ini'
echo "########################################################################"
echo "Please enter working path for backupfolder to create in HOME path: "
echo "If it is empty it use the default path 'backuphandle'. "
read inputworking

if [ ! -z "$inputworking" ] ; then
    backupfolder=$inputworking
fi
echo "The working path are: $HOME/$backupfolder"
mkdir $HOME/$backupfolder  >/dev/null 2>&1
filename="$HOME/$backupfolder/$variablefilename"
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
    logfilesbackupfolder=$HOME/klipper_config/Backuplogs
fi
echo "The NAS path are: $logfilesbackupfolder"
mkdir $logfilesbackupfolder >/dev/null 2>&1
echo "########################################################################"
echo "#######  now it run the rest from the instalation please wait!  ########"
echo "########################################################################"
sudo apt-get -qq install jq -y && sudo apt -qq install zip -y >/dev/null 2>&1
cd $home
mkdir $backupfolder  >/dev/null 2>&1
cd $backupfolder
wget https://github.com/Damada42/KlipperBackupHandle/archive/refs/heads/main.zip >/dev/null 2>&1
unzip main.zip >/dev/null 2>&1
rm main.zip >/dev/null 2>&1
find . -type f -mindepth 2 -exec mv -i -- {} . \; >/dev/null 2>&1
rm -r */ >/dev/null 2>&1

if [ ! -e $filename ]; then
  touch $filename
  echo "[variables]">> $filename
  echo "usbbackupfolder = $usbbackupfolder">> $filename
  echo "nasbackupfolder = $nasbackupfolder">> $filename
  echo "logfilesbackupfolder = $logfilesbackupfolder">> $filename
fi

