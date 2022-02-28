#!/bin/bash
set -e
#src=~/.bin/fuzzy

source ~/.zshenv #necessary cause env isn't sourced when executed by i3wm


main() {
  previous_file="$1"
  file_to_edit=`select_file $previous_file`

  loc=$(cat ~/.location)

  if [[ $file_to_edit == *.jpeg || $file_to_edit == *.jpg || $file_to_edit == *.png || $file_to_edit == *.PNG ]] ; then
	  $FUZZY/scripts/ex.sh "nomacs" "$loc/$file_to_edit"
	  #echo $loc/$file_to_edit > ~/test
	main "$file_to_edit"
  elif [[ $file_to_edit == *.pdf ]] ; then
	  $FUZZY/scripts/ex.sh "evince" "$loc/$file_to_edit"
	main "$file_to_edit"
  elif [[ $file_to_edit == *.md ]] ; then
	  $FUZZY/scripts/ex.sh "remarkable" "$loc/$file_to_edit"
  elif [[ $file_to_edit == *.xopp ]] ; then
	  $FUZZY/scripts/ex.sh "xournalpp" "$loc/$file_to_edit"
	main "$file_to_edit"
  elif [[ $file_to_edit == *.ipynb ]] ; then
	  #$FUZZY/scripts/ex.sh "jupyter-notebook" "$loc/$file_to_edit"
	  $FUZZY/scripts/ex.sh "/snap/bin/code" "$loc/$file_to_edit"
	main "$file_to_edit"
  elif [[ $file_to_edit == *.avi || $file_to_edit == *.mp4 || $file_to_edit == *.MP4 ]] ; then
	  $FUZZY/scripts/ex.sh "mpv" "$loc/$file_to_edit"
	main "$file_to_edit"
  elif [ -n "$file_to_edit" ] ; then
	  i3-msg "floating toggle"
	  $FUZZY/scripts/ex.sh "vim" "$(cat ~/.location)/$file_to_edit"
    main "$file_to_edit"
  fi
}

select_file() {
  given_file="$1"
  #i3-workspace-groups list-workspaces | head -n1 | sed 's/[[:space:]]/ /g' | cut -d ' ' -f 2 | python $FUZZY/dict.py > ~/.location
  #cd $(cat ~/.location) && i3-msg "floating toggle" > /dev/null 2>&1 && fzf -x --bind 'ctrl-n:execute(sh '$FUZZY'/locs.sh > ~/.location && pkill fzf)' --history=$FUZZY/fuz.hist --history-size=50 --preview="cat {}" --preview-window=right:65%:wrap --query="$given_file" | tr ' ' '?'

  cd $(cat ~/.location) && i3-msg "floating toggle" > /dev/null 2>&1 && export SKIM_DEFAULT_COMMAND="find . -not -regex '.*\.\(toc\|gz\|aux\|fdb_latexmk\|out\|log\|xopp~\)' -not -path '*__pycache__/*' -not -path '*/.*' -not -path '*.ipynb_checkpoints/*'" && sk -m --query="$given_file" # --preview "~/.bin/preview.sh {}" 
  #cd $(cat ~/.location) && i3-msg "floating toggle" > /dev/null 2>&1 && sk -m --query="$given_file" # --preview "~/.bin/preview.sh {}" 
  }

main ""
