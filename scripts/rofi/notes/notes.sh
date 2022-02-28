#!/bin/bash

set -u
set -e

source ~/.zshenv
readonly NOTES_FILE=$NAS/uni/Studium/todos

if [[ ! -a "${NOTES_FILE}" ]]; then
    echo "empty" >> "${NOTES_FILE}"
fi

function main()
{
    local all_notes_mod="$(cat ${NOTES_FILE} | python ~/.bin/rofi/notes/notesSort.py)" #content of saved notes
    local all_notes="$(cat ${NOTES_FILE})"

    local note=$( (echo "${all_notes_mod}")  | rofi  -columns 2 -width 1300 -dmenu -p "Note:")


	#echo ${note} > ~/txt
    local matching=$( (echo "${all_notes_mod}") | grep "^${note}$") #in case something was changed

    if [[ -n "${matching}" ]]; then #in case there was a match
		local new_notes=$( (echo "${all_notes}")  | grep -v "^$(echo ${note} | cut -c4-)$" )  #delete matched entry
    else
        local new_notes=$( (echo -e "${all_notes}\n${note}") | grep -v "^$") #add entry
    fi

    echo "${new_notes}" > "${NOTES_FILE}"

	if [ "" =  "${note}" ]; then  #only leave if escape pressed
		exit
	fi

	main #keep rofi reopening
}
main
