#!/usr/bin/env bash

declare -A LABELS
declare -A COMMANDS

COMMANDS["fstab"]="sudo vim /etc/fstab"
LABELS["fstab"]=""

COMMANDS["resolv.conf"]="sudo vim /etc/resolv.conf"
LABELS["resolv.conf"]=""

COMMANDS["grub"]="sudo vim /etc/default/grub"
LABELS["grub"]=""

COMMANDS["mirrorlist"]="sudo vim /etc/pacman.d/mirrorlist"
LABELS["mirrorlist"]=""

COMMANDS["dot"]="vim ~/.dotfiles/dot.sh"
LABELS["dot"]=""

COMMANDS["d/dotParts"]="i3-msg move scratchpad && termite -d ~/.dotfiles/parts"
LABELS["d/dotParts"]=""

COMMANDS["i3con"]="vim ~/.i3/config"
LABELS["i3con"]=""

COMMANDS["rangerRc"]="vim ~/.config/ranger/rc.conf"
LABELS["rangerRc"]=""

COMMANDS["rangerRifle"]="vim ~/.config/ranger/rifle.conf"
LABELS["rangerRifle"]=""

COMMANDS["libinput-gestures"]="vim ~/.config/libinput-gestures.conf"
LABELS["libinput-gestures"]=""

COMMANDS["d/i3blocks"]="i3-msg move scratchpad && termite -d /usr/lib/i3blocks"
LABELS["d/i3blocks"]=""

COMMANDS["d/rofiScr"]="i3-msg move scratchpad && termite -d ~/.bin/rofi"
LABELS["d/rofiScr"]=""

function print_menu()
{
    for key in ${!LABELS[@]}
    do
  echo "$key    ${LABELS}"
    done
}

function start()
{
    print_menu | rofi -dmenu -p "Edit file:" 
}

value="$(start)"

choice=${value%%\ *}
input=${value:$((${#choice}+1))}

if test -z ${choice}
then
    exit
fi

if test ${COMMANDS[$choice]+isset}
then
    eval echo "Executing: ${COMMANDS[$choice]}"
    eval ${COMMANDS[$choice]}
else
 eval  $choice | rofi
fi
