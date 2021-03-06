#!/bin/sh

loc=$1

cd $loc'/imgs'

#get last screenshot
#image=$(ls -t *.png | grep -E '^[0-9]+.png' | head -n 1 | rev | cut -d '/' -f1 | rev | cut -d '.' -f1) 
image=$(ls | grep -E '^[0-9]+.png' | cut -d '.' -f1 | sort -g | tail -n 1) 

#new filename
file=$(($image+1))".png"

#take screenshot
import $file

#optimize image
optipng -o4 $file > /dev/null 2>&1

#return command
echo "\includegraphics[width=<+++>cm]{sections/imgs/"$file"}<++>"

