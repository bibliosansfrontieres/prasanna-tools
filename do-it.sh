#!/bin/bash

DEBUGMODE=${DEBUGMODE:-1}

edebug() {
    [[ $DEBUGMODE -eq 1 ]] && echo "[+] $@" >&2
}

make_pause() {
    read -p "Press <ENTER> to continue..."
}

clean_user_files() {
    userfiles_size=$( adb shell du -sh /storage/emulated/0/ | awk '{ print $1 }' )
    edebug "User files total size: $userfiles_size"

    edebug "  Removing personal files..."
    adb shell rm -rf /storage/emulated/0/*
}

push_wallpapers() {
    edebug "  Pushing wallpapers..."
    adb shell mkdir /storage/emulated/0/DCIM
    adb push wallpapers/fd-koombook.jpg wallpapers/learn-farsi-arabe-anglais.png wallpapers/create-farsi-arabe-anglais.png wallpapers/information-farsi-arabe-anglais.png wallpapers/play-farsi-arabe-anglais.png /storage/emulated/0/DCIM/ > /dev/null
}

dump_installed_packages() {
    edebug "Dump installed packages..."
    rm -f installed_packages
    adb shell pm list packages | sed -e 's/^package://' > installed_packages
}


remove_unwanted_packages() {
    edebug "Removing unwanted packages"
    while read bl_package ; do
        edebug "Looking for ${bl_package}..."
        egrep ^$bl_package$ installed_packages && {
            edebug "  Found ${bl_package} !"
            edebug "    Clear all associated data.."
            echo adb shell pm clear $bl_package
            edebug "    Uninstalling..."
            echo adb uninstall $bl_package
            make_pause
        }
    done < packages_blacklist
}


clean_user_files
make_pause
push_wallpapers
make_pause
dump_installed_packages
make_pause
remove_unwanted_packages
