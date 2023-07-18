#!/bin/bash
echoerr() { cat <<< "$@" 1>&2; }
devs=$(lsblk --noheadings --nodeps --output NAME,SIZE,TRAN,RM | sed 's/\s\s*/|/g' | grep "usb|1$")
if [ -z $devs ]; then
    echoerr no removable USB drives found
    exit 1
fi
echo Which removable USB drives do you want to ERASE?
select dev in $devs; do
    dev=$(echo $dev | cut -d'|' -f1)
    if [ ! -b /dev/$dev ]; then
        echoerr invalid option
        exit 2
    fi
    spec="start=2048 size=32768 type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B bootable attrs=RequiredPartition"
    echo $spec | sfdisk -q --wipe always /dev/${dev} -X gpt
    if [ $? -ne 0 ]; then
        echoerr sfdisk failed, needs sudo?
        exit 3
    fi
    mkfs.fat /dev/${dev}1
    if [ $? -ne 0 ]; then
        echoerr mkfs failed
        exit 4
    fi
    mount /dev/${dev}1 /mnt 
    if [ $? -ne 0 ]; then
        echoerr mount failed
        exit 5
    fi
    find keys -type f -name "*.BEK" -exec echo {} \; -exec cp {} /mnt \;
    find keys -type f -name "*.lek" -exec echo {} \; -exec cp {} /mnt \;
    umount /mnt
    exit 0
done
