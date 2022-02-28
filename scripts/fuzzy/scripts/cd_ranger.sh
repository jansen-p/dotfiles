#!/bin/bash
#source ~/.dotfiles/zsh/zshAlias

if [[ $1 != "" ]]; then
	echo "got arg $1"
else
	loc=$(cat ~/.location)
	ranger $loc
fi
