#!/bin/bash

echo "================================================"
echo
echo -e "$YELLOW Installing packages...."
echo

#not up to date
packages="chromium nordvpn-bin fzf base-devel net-tools iotop bmenu sysstat texlive-most fwupd most xorg-xev xorg-xbacklight compton conky coreutils cups rofi dunst elinks eog file-roller gnome-calculator gnome-screenshot nautilus evince feh gutenprint system-config-printer htop i3status iscan libinput lxappearance lxsession networkmanager network-manager-applet openssh pavucontrol powertop python ranger redshift rsync tlp tree clang vim vim-latexsuite w3m xf86-input-synaptics termite texlive-lang thunderbird timeshift gimp spacefm pamac"

for file in $packages; do
	if dpkg -l $file > /dev/null 2>&1; then
		echo -e "$GREEN $file already installed!"
	else
		echo -e "$YELLOW $file ..."
		sudo apt install $file > /dev/null 2>&1
 		if dpkg -l $file > /dev/null 2>&1; then
			echo -e "$GREEN $file installed" >> $log_file
 		else
			echo -e "$RED failed to install $file!" >> $log_file
		fi
	fi
done
echo
echo -e "\n $YELLOW ===== Summary =====\n"
cat $log_file
echo
rm $log_file

