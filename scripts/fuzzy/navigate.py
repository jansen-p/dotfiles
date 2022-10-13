#!/usr/bin/env python3.7
import sys
import os
import pickle
import pwd
import argparse

from prettytable import PrettyTable
from tracker import Tracker, Matcher, bcolors

# NOTE: If single words are printed out (e.g. print("hi"), zsh will interpret them as search strings!
#      To prevent this, just add whitespace behind.


# TODO: option to "redistribute" the score, e.g. if first entries are: 9,7,2,2:
#      update them to something like 7,6,4,4


def set_parser_args(parser: argparse.ArgumentParser):
    parser.add_argument("--input", type=str, default=""),
    parser.add_argument("--num", type=int, default="-1",),
    parser.add_argument("--change_from", default="-1"),
    parser.add_argument("--change_to", type=int, default="-1",),

    parser.add_argument("--init", action="store_true")
    parser.add_argument("--update", action="store_true")
    parser.add_argument("--fetch", action="store_true")
    parser.add_argument("--delete", action="store_true")
    parser.add_argument("--path", action="store_true")
    parser.add_argument("--show", action="store_true")
    parser.add_argument("--open", action="store_true")

    parser.add_argument("--help", action="store_true")


parser = argparse.ArgumentParser(description="Process some integers.", add_help=False)
set_parser_args(parser)
args = parser.parse_args()


# get the root-dir
user = pwd.getpwuid(os.getuid())[0]
with open(os.getenv("HOME") + "/.location") as s:
    loc = s.readline().strip()
wd = os.getenv("FUZZY")
loc_name = (
    loc.split("/")[-1] if loc[-1] != "/" else loc.split("/")[-2]
)  # name of the dictionary which is stored in navi_list

# Gets printed if no args are given
if args.help or args.input in ["-h", "--help"]:
    txt = {
        "--init": "Initialized/overwrites the dictionary for the given location.",
        "--fetch": "Updates the dictionary, untracked subdirs are added.",
        "--delete": "Removes the dictionary",
        "--show": "Same as -s, just the first n entries",
        "--path": "Returns the current path",
        "--update <num> <score>": "Alters the score of dictionary entry with number <num> ",
        "": "",
        "External commands:": "",
        "ut [<depth>]": "Shows the tree of the root directory. Optional: depth",
        "ul": "Lists the currently supported locations (by the script dic.py, ZSH)",
        "un <dir> [<dst>]": "Set new path (ZSH).",
    }

    t = PrettyTable(["Flags", "Description"])
    t.align["Flags"] = "l"
    t.align["Description"] = "l"
    t.padding_width = 0
    for key, val in txt.items():
        t.add_row([bcolors.OKGREEN + key + bcolors.ENDC, val])

    print("\n" + bcolors.BOLD + bcolors.FAIL + "How to use this?" + bcolors.ENDC)
    print(t)
    print(
        "\nAll other inputs are treated as '"
        + bcolors.UNDERLINE
        + "search strings"
        + bcolors.ENDC
        + "':\nThe sorted dictionary is traversed top-bottom and checked whether input is part of the string.\n"
        + "If yes, cd to that dir, otherwise proceed.\n\nIf no dir was found, an error is thrown and directory rescanned.\n\n\n"
        + bcolors.UNDERLINE
        + "Current root directory path is saved in"
        + bcolors.ENDC
        + ": ~/.location"
    )

    exit()


if args.init:
    # initialize/overwrite the dictionary
    val = input(
        "This will initialize/overwrite the history for this dir. Continue? (y/n) "
    )
    tracker = Tracker(loc, loc_name, depth=3, init=True)
    tracker.save()
    exit()

tracker = Tracker(loc, loc_name, depth=3)

# print the first n sorted entries
if args.show:
    if args.num != -1:
        num = args.num
    else:
        num = 15

    print(bcolors.OKBLUE + "Top entries for " + loc_name + ":\n" + bcolors.ENDC)

    tracker.print(num)

# alters the dictionary: called by f.ex.: u -a 12 42
elif args.update:
    assert args.change_from != -1 and args.change_to != -1, (
        bcolors.FAIL
        + "Bad number of arguments."
        + bcolors.ENDC
        + "\nNeed two numbers: First one for the "
        + bcolors.OKBLUE
        + "entry number"
        + bcolors.ENDC
        + ", second one for the "
        + bcolors.OKBLUE
        + "new score."
        + bcolors.ENDC
    )

    tracker.set_dict_score(args.change_from, args.change_to)

elif args.delete:
    val = input("This will delete the history for this dir. Continue? (y/n) ")
    if val == "y":
        tracker.remove_dict()
        print("Deleted dictionary for " + loc_name)
    else:
        print("Aborted.")


# update the dictionary
elif args.fetch:
    tracker.update()
    tracker.save()

# print the current root folder
elif args.path:
    print(bcolors.OKBLUE + "Current path: " + bcolors.ENDC + loc)

# find a match, returns path for 'cd'
else:
    if not tracker.find_hit(
        args.input, match=Matcher.fuzzy, match_file=args.open, response=args.open
    ):  # find_hit called twice, if no match in first run, rescan dirs and try again
        if not args.open:
            tracker.update(True)  # silent
            tracker.save()
            if not tracker.find_hit(
                args.input, match=Matcher.fuzzy, response=False
            ):  # and print msg if nothing found
                print(loc)  # no match, open dir root
0
