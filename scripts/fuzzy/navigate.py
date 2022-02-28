#!/usr/bin/env python3.7
import sys
import os
import pickle
import pwd

from prettytable import PrettyTable
from tracker import Tracker, Matcher, bcolors

#NOTE: If single words are printed out (e.g. print("hi"), zsh will interpret them as search strings!
#      To prevent this, just add whitespace behind.


#TODO: option to "redistribute" the score, e.g. if first entries are: 9,7,2,2:
#      update them to something like 7,6,4,4


#get the root-dir
user = pwd.getpwuid(os.getuid())[0]
with open('/home/'+user+'/.location') as s:
    loc = s.readline().strip()
wd = os.getenv('FUZZY')
loc_name = loc.split('/')[-1] if loc[-1] != '/' else loc.split('/')[-2] #name of the dictionary which is stored in navi_list

#Gets printed if no args are given
if len(sys.argv) == 1:
    txt = {"-i": "Initialized/overwrites the dictionary for the given location.",
            "-u": "Updates the dictionary, untracked subdirs are added.",
            "-r": "Removes the dictionary",
            "ul": "Lists the currently supported locations (by the script dic.py, ZSH)",
            "us or -s": "Lists the sorted contents of the dictionary",
            "ush or -sh": "Same as -s, just the first 15 entries",
            "up or -p": "Returns the current path",
            "ua <num> <score>": "Alters the score of dictionary entry with number <num> ",
            "ut [<depth>]": "Shows the tree of the root directory. Optional: depth",
            "un <dir> [<dst>]": "Set new path (ZSH). Optional: 'search string'"}

    t = PrettyTable(['Flags', 'Description'])
    t.align["Flags"] = "l"
    t.align["Description"] = "l"
    t.padding_width = 0
    for key, val in txt.items():
       t.add_row([bcolors.OKGREEN+key+bcolors.ENDC, val])

    print("\n"+bcolors.BOLD+bcolors.FAIL+"How to use this?"+bcolors.ENDC)
    print(t)
    print("\nAll other inputs are treated as '"+bcolors.UNDERLINE+"search strings"+bcolors.ENDC+\
          "':\nThe sorted dictionary is traversed top-bottom and checked whether input is part of the string.\n"+\
          "If yes, cd to that dir, otherwise proceed.\n\nIf no dir was found, an error is thrown and directory rescanned.\n\n\n"+\
          bcolors.UNDERLINE+"Current root directory path is saved in"+bcolors.ENDC+": ~/.location")

    exit()

inp = sys.argv[1]
#inp = sys.stdin.readline().strip() #for piping


if inp == '-i':
    #initialize/overwrite the dictionary
    tracker = Tracker(loc, loc_name, depth=3, init=True) 
    tracker.save()
    exit()

tracker = Tracker(loc, loc_name, depth=3) 

#print the sorted entries
if inp == '-s':
    print(bcolors.OKBLUE+"All entries for "+loc_name+":\n"+bcolors.ENDC)
    tracker.print(None)

elif inp == '-r': #print the name of the dictionary
    print(loc_name)

#print the first 15 sorted entries
elif inp == '-sh':
    if len(sys.argv) == 3:
        try:
            num = int(sys.argv[2])
        except ValueError:
            print("Error: Second argument has to be an integer!")
            exit()
    else:
        num = 10
    
    print(bcolors.OKBLUE+"Top entries for "+loc_name+":\n"+bcolors.ENDC)
    #for x,index in zip(sort_dict(dic)[:num],range(num)):
    #    print(str(index)+": ",x[1],"-",x[0])

    tracker.print(num)

#alters the dictionary: called by f.ex.: u -a 12 42
elif inp == '-a':
    if len(sys.argv) == 4:
        try:
            num = sys.argv[2]
            score = int(sys.argv[3])

            tracker.set_dict_score(num,score)
        except ValueError:
            print("Error: Arguments have to be integers!")
            exit()
    else:
        print(bcolors.FAIL+"Bad number of arguments."+bcolors.ENDC+"\nNeed two numbers: First one for the "+bcolors.OKBLUE+"entry number"+bcolors.ENDC+", second one for the "+bcolors.OKBLUE+"new score."+bcolors.ENDC)

#update the dictionary
elif inp == '-u':
    tracker.update()
    tracker.save()

#print the current root folder
elif inp == '-p':
    print(bcolors.OKBLUE+"Current path: "+bcolors.ENDC+loc)

#find a match, returns path for 'cd'
else:
    if not tracker.find_hit(inp, Matcher.fuzzy): #find_hit called twice, if no match in first run, rescan dirs and try again
        tracker.update(True) #silent
        tracker.save()
        if not tracker.find_hit(inp, Matcher.fuzzy, False):  #and print msg if nothing found
            print(loc) #no match, open dir root
0
