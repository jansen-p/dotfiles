#!/bin/bash

for a in $@
	do udisksctl unmount -b /dev/$a
done
