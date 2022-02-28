#!/bin/bash

echo -ne "$RED Script executed as root? (y/n) => "; read answer

if [[ $answer = "y" ]] ;
	then
	echo LANG=de_DE.UTF-8 > /etc/locale.conf
	echo KEYMAP=de-latin1-nodeadkeys > /etc/vconsole.conf
	ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

	#set Hardwareclock to UTC
	timedatectl set-local-rtc 0

	echo de_DE.UTF-8 >> /etc/locale.gen
	echo en_DK.UTF-8 >> /etc/locale.gen

	echo LC_ADDRESS="de_DE.UTF-8" >> /etc/locale.conf
	echo LC_IDENTIFICATION="de_DE.UTF-8" >> /etc/locale.conf
	echo LC_MEASUREMENT="de_DE.UTF-8" >> /etc/locale.conf
	echo LC_MONETARY="de_DE.UTF-8" >> /etc/locale.conf
	echo LC_NAME="de_DE.UTF-8" >> /etc/locale.conf
	echo LC_NUMERIC="de_DE.UTF-8" >> /etc/locale.conf
	echo LC_PAPER="de_DE.UTF-8" >> /etc/locale.conf
	echo LC_TELEPHONE="de_DE.UTF-8" >> /etc/locale.conf
	echo LC_TIME="de_DE.UTF-8" >> /etc/locale.conf

	locale-gen > /dev/null 2>&1

	echo $(localectl status)

elif [[ $answer = "n" ]] ;
then
	echo -e "$RED Must be root!"
	exit
else
	exit
fi
