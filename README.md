# Prasanna

**Warning**: This repository has been moved to [GitLab](https://gitlab.com/bibliosansfrontieres/mdm/prasanna-tools).

Prasanna automates some house cleaning operations we sometimes need to
perform on tablets that were shipped within a project a long time ago.

* checks for the available storage space
* deletes user personal files
* removes unwanted applications
* push our wallpapers in place
* push a previously stored backup onto the tablet

## Disclaimer

The script was written while operating a massive update on ~100 tablets for a
specific project. It can certainly be rewritten to handle more contexts and
gain more flexibility.


## Prerequisites

* having adb(1) installed
* debug mode enabled on the tablet

### Install adb

Windows users should go to http://adbdriver.com/


You might `apt-get install android-tools-adb` (jessie) or `apt-get install adb` (stretch)

We Linux users only need the binary.

* Go to https://developer.android.com/studio/releases/platform-tools.html
* Download the [SDK Platform-Tools for
  Linux](https://dl.google.com/android/repository/platform-tools-latest-linux.zip)
* extract the needed binary: `unzip platform-tools-latest-linux.zip platform-tools/adb`
* Move that to somewhere in PATH: `mv platform-tools/adb /usr/local/bin/
  && rmdir platform-tools`

