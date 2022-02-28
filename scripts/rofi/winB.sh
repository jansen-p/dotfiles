#!/usr/bin/env bash
# author: unknown
#
#  ▓▓▓▓▓▓▓▓▓▓
# ░▓ author ▓ cirrus <cirrus@archlinux.info>
# ░▓ code   ▓ https://gist.github.com/cirrusUK
# ░▓ mirror ▓ http://cirrus.turtil.net
# ░▓▓▓▓▓▓▓▓▓▓
# ░░░░░░░░░░
#
declare -A LABELS
declare -A COMMANDS

###
# List of defined 'bangs'

COMMANDS["printerConfig"]="gksudo system-config-printer"
LABELS["printerConfig"]=""

COMMANDS["driveAnalyze"]="baobab"
LABELS["driveAnalyze"]=""

COMMANDS["ssh(Toggle)"]="gksu ~/.bin/toggleService.sh sshd"
LABELS["ssh(Toggle)"]=""

COMMANDS["wifi"]="sh ~/.bin/inet.sh"
LABELS["wifi"]=""

COMMANDS["freefilesync"]="gksu FreeFileSync"
LABELS["freefilesync"]=""

COMMANDS["timeshift"]="gksu timeshift-gtk"
LABELS["timeshift"]=""

COMMANDS["bluetooth(Toggle)"]="~/.bin/toggleProg.sh blueman-manager"
LABELS["bluetooth(Toggle)"]=""

COMMANDS["bluetoothJBL"]="bluetoothctl power on && bluetoothctl connect 04:FE:A1:F4:F1:20"
LABELS["bluetoothJBL"]=""

COMMANDS["bluetoothLP3"]="bluetoothctl power on && bluetoothctl connect AC:12:2F:AA:FE:02"
LABELS["bluetoothLP3"]=""

COMMANDS["bluetoothBRC1"]="bluetoothctl power on && bluetoothctl connect 00:11:67:5B:E3:EC"
LABELS["bluetoothBRC1"]=""

COMMANDS["bluetoothWIXB400"]="bluetoothctl power on && bluetoothctl connect 00:18:09:F9:56:4A"
LABELS["bluetoothWIXB400"]=""

COMMANDS["audio"]="pavucontrol"
LABELS["audio"]=""

COMMANDS["nordVPN(Toggle)"]="~/.bin/toggleProg.sh openvpn"
LABELS["nordVPN(Toggle)"]=""

COMMANDS["resilioSync(Toggle)"]="gksu ~/.bin/toggleService.sh rslsync"
LABELS["resilioSync(Toggle)"]=""

################################################################################
# do not edit below
################################################################################
##
# Generate menu
##
function print_menu()
{
    for key in ${!LABELS[@]}
    do
  echo "$key    ${LABELS}"
     #   echo "$key    ${LABELS[$key]}"
     # my top version just shows the first field in labels row, not two words side by side
    done
}
##
# Show rofi.
##
function start()
{
    print_menu | rofi -dmenu -p "Select:" 
    #print_menu | rofi -dmenu -mesg ">>> launch your custom rofi scripts" -i -p "rofi-bangs: "

}


# Run it
value="$(start)"

# Split input.
# grab upto first space.
choice=${value%%\ *}
# graph remainder, minus space.
input=${value:$((${#choice}+1))}

##
# Cancelled? bail out
##
if test -z ${choice}
then
    exit
fi

# check if choice exists
if test ${COMMANDS[$choice]+isset}
then
    # Execute the choice
    eval echo "Executing: ${COMMANDS[$choice]}"
    eval ${COMMANDS[$choice]}
else
 eval  $choice | rofi
 # prefer my above so I can use this same script to also launch apps like geany or leafpad etc (DK) 
 #   echo "Unknown command: ${choice}" | rofi -dmenu -p "error"
fi
