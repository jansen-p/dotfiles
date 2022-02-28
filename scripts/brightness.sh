#!/bin/bash
#USAGE: ./brightness.sh - 30    decrease brightness by 30%

VAL=$(cat /sys/class/backlight/intel_backlight/brightness)
#CHANGE=$(echo "$VAL $1 ($VAL*$2/100)" | bc)
CHANGE=$(echo "$VAL $1 $2" | bc)

echo $CHANGE > /sys/class/backlight/intel_backlight/brightness
