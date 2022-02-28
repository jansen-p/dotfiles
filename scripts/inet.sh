#!/bin/bash

WHITE='\033[1;37m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
PAT=~/.dotfiles/i3/scripts/inet.sh

echo -e "$YELLOW Connect, disconnect, show stuff, hotspot or exit? (con/dis/show/hot/scan/q): "; read answer
if [[ $answer = "con" ]];
then
	echo "Set up wifi connection!"
	echo -ne "SSID: "; read answer
	ssid=$answer
	echo -ne "password: "; read answer
	pw=$answer
	nmcli dev wifi connect $ssid password $pw
	echo "==============================================================="
	exec $PAT
elif [[ $answer = "dis" ]];
then
	echo -e "$RED Disconnecting..."
	nmcli dev disconnect wlp58s0
	echo "==============================================================="
	exec $PAT
elif [[ $answer = "show" ]];
then 
	echo
	echo
	echo -e "$WHITE Known connections:"
	echo
	nmcli con show
	echo
	echo
	echo -e "$WHITE Networks found:"
	echo
	nmcli device wifi
	echo
	echo "==============================================================="
	exec $PAT
elif [[ $answer = "hot" ]];
then
	echo "Setting up default hotspot...."
	echo
	nmcli device wifi hotspot ifname wlp58s0 ssid trszd password 1234567812345678
	echo
	echo "ssid: trszd"
	echo "pw: 1234 5678 1234 5678"
	echo
	exec $PAT
elif [[ $answer = "scan" ]];
then 
	echo "Scanning for networks...."
	echo
	nmcli device wifi rescan ifname wlp58s0
	exec $PAT
elif [[ $answer = "q" ]];
then 
	exit
else
	echo "======nope======"
	exec $PAT
fi
