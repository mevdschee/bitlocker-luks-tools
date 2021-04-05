# BitLocker tools

To open the Local Group Policy Editor, press Windows+R on your keyboard, type “gpedit.msc” into the Run dialog box, and press Enter.

see: https://www.howtogeek.com/howto/6229/how-to-use-bitlocker-on-drives-without-tpm/

## create_usb.sh

This bash script:

- ERASES everything on a USB drive
- Creates a GUID partition table (GPT) 
- Adds a single EFI Startup Partition (ESP) on it
- Formats the ESP in FAT16 format
- Copies the ".BEK" files from the "keys" folder (and subfolders) to the USB drive

Demo:

![create_usb.sh screencast](create_usb.gif)
