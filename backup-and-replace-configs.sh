#!/bin/bash
# Simple script that backs up and archives selected config-files, and then replaces them with the ones in this folder.
# Backups are saved in ~/backups.

# TODO: One day put all config files in a sub folder, and "intelligently" fetch files from there,
#       instead of manually adding file names to this script.

#set -x #Use this for debug-mode

CONFIGDIR=./configfiles
SRCDIR=~            #Note: Do NOT add quotes here, as it will affect "tilde"-expansion
DESTDIR=~/backups   #http://stackoverflow.com/questions/32276909/why-is-a-tilde-in-a-path-not-expanded-in-a-shell-script
FILENAME=configbackup-$(date "+%y-%m-%d_%H.%M.%S").tgz
mkdir -p $DESTDIR 
tar -cvf $DESTDIR/$FILENAME $SRCDIR/.emacs $SRCDIR/.bashrc $SRCDIR/.vimrc #Add more files to back up here if you want.
 
cp $CONFIGDIR/.* $SRCDIR
#cp emacs $SRCDIR/.emacs #Can add flag -i for interactive replacing.
#cp bashrc $SRCDIR/.bashrc
#cp vimrc $SRCDIR/.vimrc
