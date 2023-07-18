#!/bin/bash
echoerr() { cat <<< "$@" 1>&2; }

# Ensure 'uuid' tool is installed
if ! command -v uuid > /dev/null; then
    echoerr "command 'uuid' not found"
    exit 1
fi

# Ask for non-existing machine name
echo -n "Identify this machine: "
read machinename
if [[ -d "keys/$machinename" ]]; then
    echoerr "machine already exists"
    exit 2
fi

# Create keyfile
mkdir -p "keys/$machinename"
keyname=`uuid`
dd if=/dev/urandom bs=1 count=256 2>/dev/null > "keys/$machinename/$keyname.lek"

# Create recovery key
keyarr=()
for i in {1..8}; do
  keyarr+=($(tr -cd 0-9 </dev/urandom | head -c 6))
done
recoverkey=$(echo ${keyarr[*]} | tr ' ' '-')
cat << EOF > "keys/$machinename/luks-recover-key.txt"
Recovery key for LUKS root partition encryption

You can verify that the key name in /etc/crypttab matches the following UUID:

    $keyname

If this is the UUID based filename in /etc/crypttab, then you can use the following recovery key to unlock the partition:

    $recoverkey

If the above UUID does not match, then you can still use the installation passphrase in keyslot 0.
EOF

# Create key install script
cat << EOF > "keys/$machinename/install.sh"
#!/bin/bash
echoerr() { cat <<< "\$@" 1>&2; }
sed -i "s/none luks,discard/$keyname luks,discard,keyscript=\/bin\/luksunlockusb/g" /etc/crypttab
if [ \$? -ne 0 ]; then
    echoerr altering /etc/crypttab failed, needs sudo?
    exit 1
fi
EOF
cat << "EOF" >> "keys/$machinename/install.sh"
cat << "END" > /bin/luksunlockusb
#!/bin/sh
set -e
if [ $CRYPTTAB_TRIED -eq "0" ]; then
    sleep 3
fi
if [ ! -e /mnt ]; then
    mkdir -p /mnt
fi
for usbpartition in /dev/disk/by-id/usb-*-part1; do
    usbdevice=$(readlink -f $usbpartition)
    if mount -t vfat $usbdevice /mnt 2>/dev/null; then
        if [ -e /mnt/$CRYPTTAB_KEY.lek ]; then
            cat /mnt/$CRYPTTAB_KEY.lek
            umount $usbdevice
            exit
        fi
        umount $usbdevice
    fi
done
/lib/cryptsetup/askpass "Insert USB key and press ENTER: "
END
chmod 755 /bin/luksunlockusb
EOF
base64key=$(cat "keys/$machinename/$keyname.lek" | base64 -w 0)
cat << EOF >> "keys/$machinename/install.sh"
echo -n "$base64key" | base64 -d > $keyname.lek
echo -n "$recoverkey" > $keyname.txt
for device in \$(blkid --match-token TYPE=crypto_LUKS -o device); do
    cryptsetup luksAddKey \$device $keyname.lek
    cryptsetup luksAddKey \$device $keyname.txt
    echo \$device
done
rm $keyname.lek
rm $keyname.txt
update-initramfs -u
EOF
