#!/bin/bash

if nmcli r wifi | grep -q "disabled" ; then
    nmcli r wifi on
    notify-send -i network-wireless-disconnected "WLAN aktiviert"  
else
    nmcli r wifi off
    notify-send -i network-wireless-disconnected "WLAN deaktiviert"
fi
