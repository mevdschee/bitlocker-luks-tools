# BitLocker tools

To open the Local Group Policy Editor, press Windows+R on your keyboard, type “gpedit.msc” into the Run dialog box, and press Enter.

see: https://www.howtogeek.com/howto/6229/how-to-use-bitlocker-on-drives-without-tpm/

## create_usb.sh

This bash script:

- fully ERASES a USB drive
- creates a GUID partition table (GPT) 
- adds a single EFI Startup Partition (ESP) on it
- formats the ESP in FAT16 format
- copies the ".BEK" files from the "keys" folder (and subfolders) to the USB drive

Demo:

![create_usb.sh screencast](create_usb.gif)
