#!/bin/bash
#call this to open rofi, where search string can be entered
#then, depending on match, ranger will be opened at that location

#no string: open ranger on root dir
source ~/.zshenv  #necessary cause env isn't sourced when executed by i3wm

cur=$(cat ~/.location)
note=$(rofi -width 800 -dmenu -p "Search String:")

if [ -z $note ]; then
	ranger $cur
else
	res=$(python3 ~/.bin/fuzzy/navigate.py $note)
	ranger $res
fi
