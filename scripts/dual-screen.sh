#!/bin/bash

#export DISPLAY=:0

MONITOR=$(xrandr | grep " connected" | tail -n 1 | cut -d ' ' -f 1)
MODE=$1
POW=$2

if [[ $MODE = "only_external" ]]; then
	xrandr --output eDP-1 --off --output $MONITOR --auto
elif [[ $MODE = "only_internal" ]]; then
	xrandr --output eDP-1 --auto && xrandr --output $MONITOR --off
else
	xrandr --output eDP-1 --auto --output $MONITOR $MODE eDP-1 $POW
fi
