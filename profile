#!/bin/sh
PS1='\W$ '
cd "$HOME" || exit 1
clear
echo "************************************************************************"
echo "* PolyLinux Pathfinder: Filesystem Navigation                          *"
echo "* Read README.txt to begin. Evidence is available through data/.       *"
echo "* Submit one answer per level. Move with nextlevel and prevlevel.      *"
echo "************************************************************************"
echo "* Level: $USER"
cat README.txt
