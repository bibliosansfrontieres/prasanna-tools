#!/bin/bash

DEBUGMODE=${DEBUGMODE:-1}
BACKUPFILE="/home/tom/GRC/master-tdh.ab"

edebug() {
    [[ $DEBUGMODE -eq 1 ]] && echo "[+] $@" >&2
}

show_usage() {
    echo "Usage: `basename $0` <action>

Actions:
    clean_user_files
    push_wallappers
    dump_installed_packages
    remove_unwanted_packages
    push_backups

    info
    packages
    userfiles
"
}


make_pause() {
    read -p "Press <ENTER> to continue..."
}

check_storage_size() {
    adb shell df 2>&1 | awk ' /data/ { print $2, "total,", $3, "free" } '
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
    for bl_package in $( cat packages_blacklist ) ; do
        egrep ^$bl_package installed_packages -q
        [[ $? -eq 0 ]] && {
            edebug "  Found ${bl_package} !"
            edebug "    Clear all associated data.."
            adb shell pm clear $bl_package
            edebug "    Uninstalling..."
            adb uninstall $bl_package
        }
    done
}

push_backup() {
    edebug "Push the backup at $( date '+%H:%M:%S' )"
    time adb restore $BACKUPFILE
    edebug "    ...Finished at $( date '+%H:%M:%S' )"
}


# check
[ $# -lt 1 ] && {
    echo "Error: missing argument." >&2
    show_usage
    exit 1
}

case "$1" in
    clean_user_files|push_wallpapers|dump_installed_packages|remove_unwanted_packages|push_backups)
        $1
        ;;
    info)
        check_storage_size
        ;;
    packages)
        dump_installed_packages
        remove_unwanted_packages
        ;;
    userfiles)
        check_storage_size
        clean_user_files
        ;;
    all)
        edebug "Gathering informations"
        check_storage_size
        echo
        clean_user_files
        push_wallpapers
        dump_installed_packages
        remove_unwanted_packages
        edebug "Backup file: $BACKUPFILE"
        make_pause
        push_backup
        ;;
    *)
        echo "Error: unknown action: $1" >&2
        exit 1
        ;;
esac











