#!/usr/bin/env python3.7
import sys
from prettytable import PrettyTable
from pathlib import Path
import os

NAS = os.getenv('NAS')

uni = NAS+"/uni/Studium/1Master/"
swap = NAS+"/swap/"
home = str(Path.home())

dic = {
        "dot": home+"/.dotfiles",
        "swap": swap,
        "pyt": swap+"pyt",
        "tf": swap+"pyt/tf",
        "pi": swap+"pyt/gpio",
        "abm": swap+"abeautifulmind",
        "r": swap+"R",
        "ml": uni+"ML",
        "gui": NAS+"/uni/guitar",
        }

def get_dict():
    return dic

inp = sys.stdin.readline().strip()
if inp in dic:
    print(dic[inp])
elif inp == "list":
    t = PrettyTable(['Key', 'Path'])
    t.align["Key"] = "l"
    t.align["Path"] = "l"
    for key, val in dic.items():
       t.add_row([key, val])
    print(t)
else:
    print(home)
