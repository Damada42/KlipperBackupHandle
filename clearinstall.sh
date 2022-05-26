#!/bin/bash

variablefilename="$HOME/backupinfo.ini"

if ! [ -z "$(sed -nr "/^\[variables\]/ { :l /^backuphandlefolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)" ]; then
  echo "$(sed -nr "/^\[variables\]/ { :l /^backuphandlefolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)"
  rm -r "$(sed -nr "/^\[variables\]/ { :l /^backuphandlefolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)"
fi
if ! [ -z "$(sed -nr "/^\[variables\]/ { :l /^usbbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)" ]; then
  echo "$(sed -nr "/^\[variables\]/ { :l /^usbbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)"
  sudo rm -r "$(sed -nr "/^\[variables\]/ { :l /^usbbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)"
fi
if ! [ -z "$(sed -nr "/^\[variables\]/ { :l /^nasbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)" ]; then
  echo "$HOME/shares"
  rm -r "$HOME/shares"
fi
if ! [ -z "$(sed -nr "/^\[variables\]/ { :l /^logfilesbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)" ]; then
  echo "$(sed -nr "/^\[variables\]/ { :l /^logfilesbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)"
  rm -r "$(sed -nr "/^\[variables\]/ { :l /^logfilesbackupfolder[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $variablefilename)"
fi
