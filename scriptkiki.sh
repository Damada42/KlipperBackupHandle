#!/bin/bash
#sudo apt-get install jq -y

#System variable
SN="$(tr -d '\0' < /sys/firmware/devicetree/base/serial-number)"
#Read Path from sh script
#DIRsource="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
Dirmain=""

########### custum Variables ##########
#variables.cfg path from Klipper, must be same path in printer.cfg look https://www.klipper3d.org/Config_Reference.html#save_variables
globalvariablepath="~/scripttest/variables.cfg"
tilde="~"

#replace Tilde with home path
defaultsearchvariable=""
if [[ "$globalvariablepath" == *"$tilde"* ]]; then
  Dirmain="${globalvariablepath/"$tilde"/"$HOME"}"
else
  Dirmain="${globalvariablepath}"
fi
echo $Dirmain

responsedata=$(curl -s 'http://192.168.1.41/printer/objects/query?print_stats=state'  | jq -r '.result.status.print_stats.state')
echo "$responsedata"
if [ -z "$1" ]; then
  echo "!!!!The Searchvariable is empty !!!!!"
else
  echo "Searchvariable name is: $1"
  defaultsearchvariable=$1

  declare -A configdict
  i=0
  while read line; do
    if [[ "$line" =~ ^[^#]*= ]]; then
  #    name[i]=${line%% =*}
  #    value[i]=${line#*= }
      configdict[${line%% =*}]=${line#*= }
      ((i++))
    fi
  done < $Dirmain
#  dictleang=${#configdict[@]}
#  echo "total array elements: $dictleang"
#  #echo "total array elements: ${#name[@]}"
#  #echo "name[0]: ${name[0]}"
#  #echo "value[0]: ${value[0]}"
#  #echo "name[1]: ${name[1]}"
#  #echo "value[1]: ${value[1]}"
#  #echo "name array: ${name[@]}"
#  #echo "value array: ${value[@]}"
#  for key in "${!configdict[@]}"; do
#      echo "$key ${configdict[$key]}"
#  done
  if [ -z "${configdict[$1]}" ]; then
    echo "No Variable with name: $1 in cfg File!!! "
  else
    echo "the value from 'Searchvariable' $1 are: ${configdict[$1]}"
  fi

fi