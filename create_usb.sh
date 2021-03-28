# !/bin/bash
# change sdX to the right device
echo "start=2048 size=32768 type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B bootable attrs=RequiredPartition" | sudo sfdisk --wipe always /dev/sdX -X gpt
sudo mkfs.fat /dev/sdX1
sudo mount /dev/sda1 /mnt
sudo find keys -type f -name "*.BEK" -exec cp {} /mnt \;
# sudo fatattr +sh /mnt/*
sudo umount /mnt
