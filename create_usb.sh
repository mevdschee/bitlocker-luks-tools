# !/bin/bash
# change sdX to the right device
echo Which USB device do you want to ERASE?
select dev in $(lsblk --noheadings --nodeps --output NAME,SIZE,TRAN | sed 's/\s\s*/ /g' | grep "usb$" | cut -d" " --output-delimiter="_" -f1,2)
do
dev=$(echo $dev | cut -d_ -f1)
echo "start=2048 size=32768 type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B bootable attrs=RequiredPartition" | sudo sfdisk --wipe always /dev/${dev} -X gpt
sudo mkfs.fat /dev/${dev}1
sudo mount /dev/${dev}1 /mnt
sudo find keys -type f -name "*.BEK" -exec cp -v {} /mnt \;
# sudo fatattr +sh /mnt/*
sudo umount /mnt
exit
done
