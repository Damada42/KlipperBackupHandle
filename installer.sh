#!/bin/bash
KLIPPER_DIR="${HOME}/klipper"
KIAUH_DIR="${HOME}/kiauh"
backuphandlefolder="$HOME/klipper_config/.backuphandle"
usbbackupfolder="/media/usbstickdata"
nasbackupfolder="$HOME/shares/klipper"
logfilesbackupfolder="$HOME/klipper_config/Backuplogs"
variablefilename="$HOME/backupinfo.ini"
mountfoldernas="//192.168.1.1/NASDISK/NASFOLDER"
nasuser="user"
naspassword="password"
fstabfile="/etc/fstab"
install()
{
  echo "########################################################################"
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
  echo " "
  echo "########################################################################"
  echo "Please enter networkpath to Nas for creating fstab mount: "
  echo "If it is empty it use the default path '//192.168.1.1/NASDISK/NASFOLDER'. "
  read networkpathnas
  if [ ! -z "$networkpathnas" ] ; then
      mountfoldernas=$networkpathnas
  fi
  echo "The NAS path are: $mountfoldernas"
  while
    nasconnection
    read -p  "Are the Userdata right?? y/n :" nasyn
    case $nasyn in
      Y|y|Yes|yes) false;;
      * ) true;;
    esac
  do
    :
  done
  echo " "
  echo "Please enter working path for backuphandlefolder to create in '$HOME/klipper_config' path: "
  echo "If it is empty it use the default path '.backuphandle'. "
  if [ ! -z "$inputworking" ] ; then
      backuphandlefolder=$HOME/klipper_config/.$inputworking
  fi
  echo "The working path are: $backuphandlefolder"
  mkdir $backuphandlefolder  >/dev/null 2>&1
  while
    echo " "
    PS3='Please enter the type of savemode for backup: '
    options=("usb" "nas" "both")
    select opt in "${options[@]}"
    do
        case $opt in
            "usb")
                echo "you chose the savemode 'usb'"
                ;;
            "nas")
                echo "you chose the savemode 'nas'"
                ;;
            "Option 3")
                echo "you chose choice $REPLY which is $opt"
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
    savemode=$opt
    read -p  "Are the 'savemode' type: $savemode right?? y/n :" modeyn
    case $modeyn in
      Y|y|Yes|yes) false;;
      * ) true;;
    esac
  do
    :
  done
  if [ ! -z "$inputworking" ] ; then
      backuphandlefolder=$HOME/klipper_config/.$inputworking
  fi
  echo "The working path are: $backuphandlefolder"
  mkdir $backuphandlefolder  >/dev/null 2>&1
  echo " "
  echo "########################################################################"
  echo "Please enter USB path to creat it in 'media' folder: "
  echo "If it is empty it use the default path 'usbstickdata'. "
  read inputusb
  if [ ! -z "$inputusb" ] ; then
      usbbackupfolder=/media/$inputusb
  fi
  echo "The USB path are: $usbbackupfolder"
  sudo mkdir $usbbackupfolder  >/dev/null 2>&1
  sudo chmod 777 $usbbackupfolder >/dev/null 2>&1
  echo " "

  echo " "
  echo "########################################################################"
  echo "Please enter Logfile path to creat it in '$HOME/klipper_config' folder: "
  echo "If it is empty it use the default path 'Backuplogs'. "
  read inputlogfiles
  if [ ! -z "$inputlogfiles" ] ; then
      logfilesbackupfolder=$HOME/klipper_config/$inputlogfiles
  fi
  echo "The NAS path are: $logfilesbackupfolder"
  mkdir $logfilesbackupfolder
  cd $logfilesbackupfolder
  sleep 1s
  touch log_ready.log
  touch log_fail.log
  echo "########################################################################"
  echo "#######  now it run the rest from the instalation please wait!  ########"
  echo "########################################################################"
  echo " "
  echo "####################  Install missing packages. ########################"
  echo "########################################################################"
  sudo apt-get install cifs-utils -y >/dev/null 2>&1
  sudo apt-get -qq install jq -y >/dev/null 2>&1
  sudo apt -qq install zip -y >/dev/null 2>&1
  echo " "
  echo "##############  Install credentials and mount nas. #####################"
  echo "########################################################################"
  mkdir $HOME/.credentials
  cd $HOME/.credentials
  touch smbcredentials
  sleep 1s
  echo "username=$nasuser">> smbcredentials
  echo "password=$naspassword">> smbcredentials
  sleep 1s
  sudo su -c "echo '$mountfoldernas $nasbackupfolder cifs credentials=$HOME/.credentials/smbcredentials,users,uid=1000,gid=1000,x-systemd.automount,x-systemd.requires=network-online.target 0 0' >> $fstabfile"
  sudo mount-a
  cd $backuphandlefolder
  echo " "
  echo "################## Download and copy Backup scripts ####################"
  echo "########################################################################"
  wget https://raw.githubusercontent.com/Damada42/KlipperBackupHandle/main/handlebackup.sh >/dev/null 2>&1
  wget https://raw.githubusercontent.com/Damada42/KlipperBackupHandle/main/Backup.sh >/dev/null 2>&1
  echo " "
  echo "################ Copy and restarting Klipper service ###################"
  echo "########################################################################"
  if cp "${KIAUH_DIR}/resources/gcode_shell_command.py" "${KLIPPER_DIR}/klippy/extras"; then
    sudo service klipper restart
    echo "shell_command option copy done!"
  else
    echo "Cannot copy shell_command file from kiauh! Please install it manuell with starting kiauh!"
  fi
  echo " "
  echo "################ Create backupinfo.ini file ###################"
  echo "########################################################################"
  if [ ! -e $variablefilename ]; then
    touch $variablefilename
    echo "[variables]">> $variablefilename
    echo "backuphandlefolder = $backuphandlefolder">> $variablefilename
    echo "usbbackupfolder = $usbbackupfolder">> $variablefilename
    echo "nasbackupfolder = $nasbackupfolder">> $variablefilename
    echo "logfilesbackupfolder = $logfilesbackupfolder">> $variablefilename
    echo "BackupAfterPrint = 0">> $variablefilename
    echo "save_mode = $savemode">> $variablefilename
  fi
}

nasconnection()
{
    echo " "
    echo "########################################################################"
    echo "Please enter user and password for connecting to your NAS: "
    echo "PLEASE Check the DATA are right!!!! "
    echo "If it is empty it use the defaults 'user' and 'password'. "
    echo "First enter the username: "
    read inputuser
    if [ ! -z "$inputuser" ] ; then
        nasuser=$inputuser
    fi
    echo "Now the password: "
    read inputpw
    if [ ! -z "$inputpw" ] ; then
        naspassword=$inputpw
    fi
    echo "The NAS username are: $nasuser and the password are: $naspassword "
}
echo "########################################################################"
echo "#######  WARNING! IT WILL RESTART KLIPPER SERVICE!!!  ########"
echo "########################################################################"
read -p  "Do you want continue??" yn
case $yn in
  Y|y|Yes|yes) install;;
  N|n|No|no) exit;;
  * ) exit;;
esac

