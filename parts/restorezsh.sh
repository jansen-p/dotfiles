#!/bin/bash

backup=$home/.zshbackup

#echo "$RED NOT WORKING YET"
#exit

if $(file ~/.zshrc || file ~/oh-my-zsh) | grep cannot ;#> /dev/null 2>&1;
then
	echo -e "$RED failed to install oh-my-zsh!!" > $log_file
else 
	echo -e "$GREEN installed oh-my-zsh." > $log_file
fi
	
#restore dotfiles, move default installation to backup directory
echo -ne  "$YELLOW Restory the dotfile configuration of oh-my-zsh? (y/n) => "; read answer
echo
if [[ $answer = "y" ]] ;
then
	mkdir $backup > /dev/null #2>&1
	mv $home/.zshrc $backup #> /dev/null 2>&1
	mv $home/.oh-my-zsh $backup #> /dev/null 2>&1

	if file $home/.zshrc | grep cannot && file $home/.zshrc | grep cannot;
	then
		echo -e "$GREEN all files moved!" >> $log_file
	else
		echo -e "$RED Failed to move files!" >> $log_file
	fi

	echo
	echo "$YELLOW Creating symlinks..." 

	ln -sf $dotdir/zsh/zshrc $home/.zshrc
	ln -sf $dotdir/zsh/oh-my-zsh $home/.config/oh-my-zsh

		
	if $(file ~/.zshrc || file ~/.config/oh-my-zsh) | grep cannot > /dev/null;# 2>&1;
	then
		echo -e "$RED failed to create all symlinks!!" >> $log_file
	else 
		echo -e "$GREEN Symlinked all files." >> $log_file
	fi
else
	echo -e "$GREEN Keeping default config"
fi

echo -e "\n $YELLOW ===== Summary =====\n"
cat $log_file
echo
rm $log_file > /dev/null 2>&1
echo -e "$GREEN Default files were moved to $backup!"
