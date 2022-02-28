#!/bin/bash

#add restore function
#check colorsupport of terminal
#check internet connection before installing packages
#fileconflicts during installation
#dont show "package not found" errors...
#select packages you want to install, not forced to inst. all

#DIRECTORIES
export log_file=~/install_log.txt
export home=$HOME
export dotdir=$home/.dotfiles
export backup=$home/.dotfiles.def

export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'

source $dotdir/parts/sources

#{{{start subprograms in subshells
symlinks() {
	($dotdir/parts/symlinks.sh)
	}
install() {
	($dotdir/parts/install.sh)
}
setlang() {
	($dotdir/parts/setlang.sh)
}
zsh() {
	($dotdir/parts/installzsh.sh)
}
reszsh() {
	($dotdir/parts/restorezsh.sh)
}
#}}}

#***************************************

choice () {
    local choice=$1
    if [[ ${opts[choice]} ]] # toggle
    then
        opts[choice]=
    else
        opts[choice]=+
    fi
}

PS3='Please enter your choice: '
while :
do
    clear
    options=("Symlink files ${opts[1]}" "Install programs ${opts[2]}" "Set system/keyboard language ${opts[3]}" "Install zsh shell ${opts[4]}" "Restore zsh shell ${opts[5]}" "Done")
    select opt in "${options[@]}"
    do
        case $opt in
            "Symlink files ${opts[1]}")
                choice 1
                break
                ;;
            "Install programs ${opts[2]}")
                choice 2
                break
                ;;
            "Set system/keyboard language ${opts[3]}")
                choice 3
                break
                ;;
            "Install zsh shell ${opts[4]}")
                choice 4
                break
                ;;
            "Restore zsh shell ${opts[5]}")
                choice 5
                break
                ;;
            "Done")
                break 2
                ;;
            *) printf '%s\n' 'invalid option';;
        esac
    done
done

echo
SET=''
printf '%s\n' 'Options chosen:'
for opt in "${!opts[@]}"
do
    if [[ ${opts[opt]} ]]
    then
		if [[ $opt = '1' ]]
		then
			SET+=' symlinks'
		elif [[ $opt = '2' ]]
		then
			SET+=' install'
		elif [[ $opt = '3' ]]
		then 
			SET+=' setlang'
		elif [[ $opt = '4' ]]
		then 
			SET+=' zsh'
		else 
			SET+=' reszsh'
		fi
		printf '%s\n' "Option $opt"
    fi
done

echo

echo -ne "$YELLOW Continue? (y) \n"; read answer
echo

if [[ $answer = "y" ]] ;
then
	for i in $SET
	do
		$i
	done
else
	exit
fi     
