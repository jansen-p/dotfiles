#!/bin/bash

#echo "$1" > ~/test

vim -c "edit $(cat ~/.bin/test)"
rm ~/.bin/test
