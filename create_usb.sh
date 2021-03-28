# !/bin/bash
# change sdX to the right device
echo Which removable USB drives do you want to ERASE?
devs=$(lsblk --noheadings --nodeps --output NAME,SIZE,TRAN,RM | sed 's/\s\s*/|/g' | grep "usb|1$")
if [ -z $devs ]; then
echo no removable USB drives found
exit
fi
select dev in $devs
do
dev=$(echo $dev | cut -d'|' -f1)
spec="start=2048 size=32768 type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B bootable attrs=RequiredPartition" 
echo $spec | sudo sfdisk -q --wipe always /dev/${dev} -X gpt
if [ $? -ne 0 ]; then
echo fdisk failed
exit
fi
sudo mkfs.fat /dev/${dev}1
sudo mount /dev/${dev}1 /mnt 
if [ $? -ne 0 ]; then
echo mount failed
exit
fi
sudo find keys -type f -name "*.BEK" -exec cp -v {} /mnt \;
# sudo fatattr +sh /mnt/*
sudo umount /mnt
exit
done
