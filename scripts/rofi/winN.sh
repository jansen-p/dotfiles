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

COMMANDS["chromium"]="chromium"
LABELS["chromium"]=""

COMMANDS["pdf-Editor"]="masterpdfeditor5"
LABELS["pdf-Editor"]=""

COMMANDS["gimp"]="gimp"
LABELS["gimp"]=""

COMMANDS["netflix"]="firefox www.netflix.com/de-en/login"
LABELS["netflix"]=""

COMMANDS["packages"]="pamac-manager"
LABELS["packages"]=""

COMMANDS["screenshot"]="gnome-screenshot"
LABELS["screenshot"]=""

COMMANDS["scan"]="gscan2pdf"
LABELS["scan"]=""

COMMANDS["vscode"]="code"
LABELS["vscode"]=""

COMMANDS["kodi"]="kodi"
LABELS["kodi"]=""

COMMANDS["printer"]="printer"
LABELS["printer"]=""

COMMANDS["dropbox(Toggle)"]="~/.bin/toggleProg.sh dropbox"
LABELS["dropbox(Toggle)"]=""

COMMANDS["googledrive(Toggle)"]="~/.bin/toggleProg.sh insync"
LABELS["googledrive(Toggle)"]=""


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
