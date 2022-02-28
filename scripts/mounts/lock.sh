#!/bin/bash

if [[ $1 = "" ]]; then
	udisksctl unmount -b /dev/dm-0
	udisksctl lock -b /dev/mmcblk0p2
else
	udisksctl unmount -b /dev/dm-0
	udisksctl lock -b /dev/$1
fi
	
