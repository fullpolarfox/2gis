#!/bin/bash

res="360"
workdir=$(pwd)
list=()
resize() {
for f in $*; do
local newname="${f%.*}_thumbnail.${f##*.}"
if [ -f $f ]; then
  read w h < <(identify -format "%w %h" "$f")
    if [ "$w" -gt "$h" ]; then
    convert -scale $res $f $newname
  else
    convert -scale "x"$res $f $newname
    fi
fi
done
}

if [ -z $1 ]; then
  while read -r -d $'\n'; do
    list+=("$REPLY")
  done < <(find $workdir -iname "*.jpg" ! -iname "*_thumbnail*" -type f)
  resize ${list[@]}
else
  if [ -f $1 ]; then
    while read -r line; do
      list+=("$line")
    done < <(grep ".jpg" $1)
    resize ${list[@]}
  else
    echo "no file"
    exit 1
  fi
fi
