#!/usr/bin/env python3.7
import sys
from prettytable import PrettyTable
from pathlib import Path
import os

NAS = os.getenv('NAS')

uni = NAS+"/uni/1Master/2.Sem/"
swap = NAS+"/swap/"
home = str(Path.home())

dic = {
        "dot": home+"/.dotfiles",
        "swap": swap,
        "pyt": swap+"Coding/pyt",
        "tf": swap+"Coding/pyt/tf",
        "pi": swap+"Coding/pyt/gpio",
        "abm": swap+"Coding/abeautifulmind",
        "r": swap+"Coding/R",
        "gui": swap+"guitar",
        "mlgs": uni+"MLGS",
        "bio": uni+"Bionik",
        "cloud": uni+"CloudComputing",
        "cps": uni+"CyberPhysicalSystems",
        "deep": uni+"DeepLearning",
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
