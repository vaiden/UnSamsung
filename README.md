# UnSamsung
A small shell script to remove Samsung bloatware from a Samsung device. You control what to uninstall.

## The what
This script allows you to remove Samsung bloatware from your Samdung android device.

It lists all installed Samsung apps and lets you choose which to remove. Even those that Samsung would not allow you to uninstall via the  device itself.

## The how
* Install ADB on your computer and connect your Samdung device to it using one of the 100s of tutorials available on the web.
* Then either:
    * Run<BR/>`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vaiden/UnSamsung/main/unsamsung.sh)"`
    * Download the script, inspect it thoroughly and then execute it locally.

#### Parameters
* `-s` to remove both regular and system Samsung bloatware.
    * Example: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vaiden/UnSamsung/main/unsamsung.sh)" -- -s`
    * Example 2: `./unsamsung.sh -s`
    * You *must have root access* on your device to be able to uninstall system apps.

#### Displaying app names
By deafult the script would only display package names. <BR/>In order to translate each to a full application name and version you need to have AAPT installed on your device, preferably to `/data/local/tmp/`.

**Regardless, the script works fine without AAPT.**

More info here:<BR/>
https://gokulnc.github.io/blog/find-app-name-adb/
https://github.com/JonForShort/android-tools/tree/master/build

## License
This script is published under the [Unlicense license](https://www.tldrlegal.com/license/unlicense). You may do whatever you want with it. Knock yourself out as long as you don't come crying back to me.