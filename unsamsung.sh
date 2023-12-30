#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
WHITE_B='\033[1;37m'

# Remove whitespace
function remWS {
    if [ -z "${1}" ]; then
        cat | tr -d '[:space:]'
    else
        echo "${1}" | tr -d '[:space:]'
    fi
}

function checkAAPT {
    adb shell /data/local/tmp/aapt &> /dev/null
    echo $?
}


adb shell pwd &> /dev/null
if [ "$?" -ne 0 ] 
then
    echo No device detected or too many devices connected.
    exit 127
fi

extra_args="-3"
for arg in "$@"
do
  if [ "$arg" == "-s" ]; then
    echo "We will try and remove system packages. You will need ${RED}root${NC} access to succeed!"
    extra_args=""
  fi
done
if [ "$extra_args" == "-3" ]
then
    echo -e "Add the ${WHITE_B}-s${NC} flag if you want to also handle system packages. You will need ${RED}root${NC} access to succeed."
fi

aapt_found=$(checkAAPT)
if [ "$aapt_found" -eq 2 ]
then 
    echo AAPT found on the device. 
else
    echo AAPT not found on the device. Everything would still work fine but application names will not be displayed, just packages.
    echo More info here:
    echo - https://gokulnc.github.io/blog/find-app-name-adb/
    echo - https://github.com/JonForShort/android-tools/tree/master/build
fi

removed_packages=0
for pkg in $(adb shell cmd package list packages -e $extra_args | grep samsung | cut -d':' -f2); do 
    pkg=$(remWS $pkg)
    apk_loc="$(adb shell pm path $pkg | cut -d':' -f2 | remWS)"
    if [ "$aapt_found" -eq 2 ]
    then 
        apk_name="$(adb shell /data/local/tmp/aapt dump badging $apk_loc | pcregrep -o1 $'application-label:\'(.+)\'' | remWS)"
        apk_info="$(adb shell /data/local/tmp/aapt dump badging $apk_loc | pcregrep -o1 '\b(package: .+)')"
        apk_version=v$(echo $apk_info | pcregrep -io1 -e $'\\bversionName=\'(.+?)\'')
    else
        apk_name="NAME_UNKNOWN"
        apk_version="v?"
    fi
    
    echo ""
    echo "----------------------------------------------"
    echo -e "${WHITE_B}$apk_name${NC} $apk_version ${WHITE_B}$pkg${NC} ($apk_loc)"
    echo "Do you wanna remove this package? [Y/N]"

    read -n 1 key
    echo ""
    if [[ $key == "y" ]] || [[ $key == "Y" ]]
    then
        if [[ "$app_loc" == *"/system"* ]]
        then
            adb shell pm uninstall --user 0 $pkg
        else
            adb shell pm uninstall $pkg
        fi
        if [ "$?" -eq 0 ] 
        then
           removed_packages=$((removed_packages+1))
        fi
    fi 
done

echo $removed_packages packages removed succeesfuly.

