#!/bin/bash
PID=$(pidof -x $1)

if [[ $PID != "" ]];
then
	case $1 in
		blueman-applet)
			kill $PID
			rfkill block bluetooth
			notify-send -u critical "quit $1" 
			;;
		insync)
			insync quit
			notify-send -u critical "quit GDrive"
			;;
		openvpn)
			nordvpn d
			;;
		*)
			kill $PID
			notify-send -u critical "quit $1"
			;;
	esac
else
	case $1 in
		blueman-applet)
			rfkill unblock bluetooth && blueman-applet
			notify-send "$1 started"
			;;
		insync)
			insync start
			notify-send "GDrive started"
			;;
		openvpn)
			nordvpn c New_Zealand
			;;
		*)
			$1 &
			notify-send "$1 started"
			;;
	esac
fi
