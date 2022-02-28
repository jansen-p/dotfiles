#user_inp=$(DISPLAY=:0 zenity --entry --text="Choose e-DP1 (0) or DP1 (1)")
user_inp=$1

if [ $user_inp = 0 ]; then
	echo "chose 0"
	#name of internal display
	choice="eDP-1"
elif [ $user_inp = 1 ]; then
	echo "chose 1"
	#get name of external display
	choice=$(xrandr | grep " connected" | tail -n 1 | cut -d ' ' -f 1)
fi

xsetwacom list devices | tr "[:blank:]" " " | tr -s "[:blank:]" | cut -d ' ' -f 8 | xargs -n 1 -I {} xsetwacom set {} MapToOutput $choice
