#!/bin/sh



userfiles_size=$( adb shell du -sh /storage/emulated/0/ | awk '{ print $1 }' )
echo "User files total size: $userfiles_size"

echo "Removing personal files..."
#adb shell rm -rf /storage/emulated/0/DCIM/* /storage/emulated/0/ComicStrip \
#    /storage/emulated/0/Android/* \
#    /storage/emulated/0/Download/* /storage/emulated/0/

adb shell rm -rf /storage/emulated/0/*

echo "Pushing wallpapers..."
adb shell mkdir /storage/emulated/0/DCIM
adb push fd-koombook.jpg learn-farsi-arabe-anglais.png create-farsi-arabe-anglais.png information-farsi-arabe-anglais.png play-farsi-arabe-anglais.png /storage/emulated/0/DCIM/
