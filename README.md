---
## Dotfiles
---

## The subdirectories

1. **backgrounds:** well.. backgrounds
2. **bash:** contains all bash config files (not in use)
3. **coding** contains configuration folders for coding programs (jupyter etc.)
4. **config** contains config files/folders
5. **fonts:** collection of different fonts
6. **i3:** all config files of the tiling manager i3wm 
7. **parts:** maintenance of the dotfile directory. Read below
7. **scripts:** contains all sorts of scripts
8. **zsh:** varioud zshconfigs for different systems (e.g. raspi, laptops) + oh-my-zsh, which contains lots of themes and plugins
9. **rest:** dot.sh for controlling the scripts in "parts", and other random files

---

## Using the dotfile-scripts
**dot.sh** is used to do a couple of things:

The options:

1. Automatically create necessary symbolic links from this directory to the corresponding file destination. All files which already exist are getting backed up, you can find them hidden in the homedir. 
2. Installs basic packages from the official repos, specified package list is outdated
3. Sets the system language and keyboard language, maybe not working properly. Doesn't brick the system though if it doesn't work
4. Installs oh-my-zsh, not really useful since it's already included in the dotfiles. This is a default oh-my-zsh installation. (~/.oh-my-zsh)
5. It moves ~/.oh-my-zsh to a backup folder and links the necessary files.

---

## The navigation script (scripts/fuzzy)

The folder structure of some directory is saved such that it's possible to quickly navigate through this folder: Call 'u' in the terminal to access a short docu (source zsh/zshAlias if necessary). The mentioned 'search strings' are fuzzy-matched with the internal folder structure, which results in quickly switching directories inside this specific folder.

A number of other script are making use of this, e.g. shortcuts in ranger to open this folder, a file fuzzy finder which searches for files in this folder, and most importantly i3wm itself: 

The workspaces are [grouped](https://github.com/infokiller/i3-workspace-groups) according to the user input. If that input matches the dictionary keys specified in scripts/fuzzy/dic.py, the path to the above mentioned folder is updated accordingly.
