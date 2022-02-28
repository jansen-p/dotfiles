#!/bin/bash

if [[ $1 == 'vim' ]]; then
	$1 $2
else
	nohup $1 $2 &
	rm ~/nohup.out
fi

pkill fzf
