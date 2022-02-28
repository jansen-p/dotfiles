#!/bin/bash

#if ps auxw | grep -P '\b'$1'(?!-)\b';
if systemctl status $1 | grep running;
then
	systemctl stop $1
	#case $1 in
	#	blueman-applet)
	#		kill $PID
	#		rfkill block bluetooth
	#		notify-send "quit $1" 
	#		;;
	#	*)
	#		kill $PID
	#		notify-send -u critical "quit $1"
	#		;;
	#esac
else
	systemctl start $1
	#case $1 in
	#	blueman-applet)
	#		rfkill unblock bluetooth && blueman-applet
	#		notify-send "$1 started"
	#		;;
	#	*)
	#		$1 &
	#		notify-send "$1 started"
	#		;;
	#esac
fi
