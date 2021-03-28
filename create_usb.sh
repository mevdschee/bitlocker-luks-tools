# !/bin/bash
echoerr() { cat <<< "$@" 1>&2; }
devs=$(lsblk --noheadings --nodeps --output NAME,SIZE,TRAN,RM | sed 's/\s\s*/|/g' | grep "usb|1$")
if [ -z $devs ]; then
echoerr no removable USB drives found
exit 1
fi
echo Which removable USB drives do you want to ERASE?
select dev in $devs
do
dev=$(echo $dev | cut -d'|' -f1)
spec="start=2048 size=32768 type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B bootable attrs=RequiredPartition" 
echo $spec | sfdisk -q --wipe always /dev/${dev} -X gpt
if [ $? -ne 0 ]; then
echoerr sfdisk failed, needs sudo?
exit 2
fi
mkfs.fat /dev/${dev}1
if [ $? -ne 0 ]; then
echoerr mkfs failed
exit 3
fi
mount /dev/${dev}1 /mnt 
if [ $? -ne 0 ]; then
echoerr mount failed
exit 4
fi
find keys -type f -name "*.BEK" -exec cp -v {} /mnt \;
umount /mnt
exit 0
done
