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

source ~/.zshenv

###
# List of defined 'bangs'
COMMANDS["dow"]="ranger ~/Downloads"
LABELS["dow"]=""

COMMANDS["swap"]="ranger $NAS/swap"
LABELS["swap"]=""

COMMANDS["python"]="ranger $NAS/swap/pyt"
LABELS["python"]=""

COMMANDS["abm"]="ranger $NAS/swap/abeautifulmind"
LABELS["abm"]=""

COMMANDS["uni"]="ranger $NAS/uni/Studium/1Master"
LABELS["uni"]=""

COMMANDS["gui"]="ranger $NAS/uni/guitar"
LABELS["gui"]=""

COMMANDS["bluetooth"]="ranger ~/Downloads/bluetooth"
LABELS["bluetooth"]=""

# COMMANDS[".bin"]="spacefm -r '/home/dkm/bin'"
# LABELS[".bin"]=".bin"

# COMMANDS["#screenshot"]='/home/dka/bin/screenshot-scripts/myscreenshot.sh'
# LABELS["#screenshot"]="screenshot"

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
