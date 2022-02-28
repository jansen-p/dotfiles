#!/bin/bash

if [[ $1 = "" ]]; then
	udisksctl unlock -b /dev/mmcblk0p2
	udisksctl mount -b /dev/dm-0
else
	udisksctl unlock -b /dev/$1
	udisksctl mount -b /dev/dm-0
fi
