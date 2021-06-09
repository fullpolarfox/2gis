#!/bin/bash

res="360"
workdir=$(pwd)
list=()

resize() {
f=$*
local newname="${f%.*}_thumbnail.${f##*.}"
if [ -f "$f" ]; then
  read w h < <(identify -format "%w %h" $f)
    if [ "$w" -gt "$h" ]; then
    convert -scale $res $f $newname
  else
    convert -scale "x"$res $f $newname
   fi
else
  echo "no file"
fi
}

if [ -z $1 ]; then
  while read -r -d $'\n'; do
    resize "$REPLY"
  done < <(find $workdir -iname "*.jpg" ! -iname "*_thumbnail*" -type f)
else
  if [ -f $1 ]; then
    while read -r line; do
     resize "$line"
    done < <(grep ".jpg" $1)
  else
    echo "no file"
    exit 1
  fi
fi
