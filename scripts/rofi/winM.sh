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

COMMANDS["übertragen"]="xrandr --output eDP1 --auto && xrandr --output DP1 --mode auto"
LABELS["übertragen"]=""

COMMANDS["oben"]="xrandr --output DP1 --auto --above eDP1"
LABELS["oben"]=""

COMMANDS["links"]="xrandr --output DP1 --mode auto --left-of eDP1"
LABELS["links"]=""

COMMANDS["rechts"]="xrandr --output DP1 --mode auto --right-of eDP1"
LABELS["rechts"]=""

COMMANDS["ext"]="xrandr --output eDP1 --off && xrandr --output DP1 --mode auto"
LABELS["ext"]=""

COMMANDS["int"]="xrandr --output eDP1 --auto && xrandr --output DP1 --off"
LABELS["int"]=""

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
