#!/bin/bash

#F1|F2: symlink $dotdir/F1 to $home/F2
links="
	backgrounds|Bilder/backgrounds
	i3|.i3
	fonts|.fonts
	scripts|.bin
	config/htop|.config/htop
	config/jack|.config/jack
	config/nvim|.config/nvim
	config/ranger|.config/ranger
	config/rofi|.config/rofi
	config/termite|.config/termite
	config/ulauncher|.config/ulauncher
	config/xournalpp|.config/xournalpp
	config/libinput-gestures.conf|.config/libinput-gestures.conf
	config/powerlineConfig.zsh|.p10k.zsh
	bash/profile|.profile
	bash/bashrc|.bashrc
	config/xinitrc|.xinitrc
	config/latexmk|.latexmkrc
	coding/jupyter|.jupyter
	coding/vim/vimrc|.vimrc
	coding/vim/tex.vim|.vim/bundle/quicktex/ftplugin/tex.vim
	"

IFS="|"


echo "================================================================="
echo
echo -ne  "$YELLOW Really want to replace existing dotfiles? (y/n) \n"; read answer
echo
if [[ $answer = "y" ]] ;
then
	# CREATE BACKUP DIRECTORY
	echo -e "$YELLOW Creating backup directory...."
	echo
	mkdir $backup > /dev/null 2>&1
	if file $backup | grep cannot ; then
		echo -e "$RED Failed. Exiting..."
		exit
	else
		echo -e "$GREEN Done."
		echo
	fi

	# MOVE DOTFILES TO BACKUP DIRECTORY
	echo -e "$YELLOW Moving dotfiles to backup directory...."
	echo

	for file in $links
	do
		set -- $file
		mv $home/$2 $backup > /dev/null 2>&1
		if file $home/$2 | grep cannot > /dev/null 2>&1;
		then
			echo -e "$GREEN $home/$2 moved!" >> $log_file
		else
			echo -e "$RED failed to move $home/$2 !!!" >> $log_file
		fi
	done

	echo >> $log_file

	# SYMLINK DOTFILES
	echo
	echo -ne  "$YELLOW Restore dotfiles? (y/n) => "; read answer
	echo
	if [[ $answer = "y" ]] ;
	then
		echo -e "$YELLOW Restoring...."
		echo
		#create all directories first so there are no errors during linking!!!
		mkdir -p $home/.vim/bundle/quicktex/ftplugin

		for i in $links
		do
			set -- $i
			ln -sf $dotdir/$1 $home/$2

			if file $home/$2 | grep cannot > /dev/null 2>&1;
			then
				echo -e "$RED Failed to symlink to $home/${2} !!" >> $log_file
			else
				echo -e "$GREEN Symlinked $home/${2}." >> $log_file
			fi
		done


	elif [[ $answer = "n" ]] ;
	then
		echo -e "$RED Restoring symlinks cancelled."
	else
		echo -e "$RED Try again!"
		echo
		symlinks
	fi

	echo -e "\n $YELLOW ===== Summary =====\n"
	cat $log_file
	echo
	rm $log_file > /dev/null 2>&1
	echo -e "$GREEN Default dotfiles were moved to $backup and/or $backuproot!"
	echo -e "Don't forget to symlink $dotdir/vim/jellybeans.vim to /usr/share/vim/???/colors !!"
	exit

elif [[ $answer = "n" ]] ;
then
	echo -e "$RED Creating symlinks cancelled."
	exit
else
	echo -e "$RED Try again!"
	echo
	symlinks
fi
