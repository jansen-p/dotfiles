#!/bin/bash
source ~/.zshenv

i3-workspace-groups list-workspaces | sed 's/[[:space:]]/ /g' | cut -d ' ' -f 2 | sed '/^$/d' | head -n1 | python3 $FUZZY/dic.py > ~/.location
