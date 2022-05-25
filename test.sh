#!/bin/bash

#Installation Path for gateway
Installpath="/srv/cms"

declare -a failarray=()
date --date="+3600 seconds" '+%Y-%m-%d %T'
failarray+=($date)
failarray+=("do geht wos net")
failarray+=("jetzt scho")
for value in "${failarray[@]}"
do
     echo $value
done
