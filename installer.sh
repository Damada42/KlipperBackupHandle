#!/bin/bash


sudo apt-get install jq -y && sudo apt install zip -y
cd $home
mkdir backuphandle
cd backuphandle
wget https://github.com/Damada42/KlipperBackupHandle/archive/refs/heads/main.zip
unzip main.zip
rm main.zip

