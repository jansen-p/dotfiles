#!/bin/bash

for a in $@
	do udisksctl mount -b /dev/$a
done
