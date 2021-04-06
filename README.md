# BitLocker tools

To open the Local Group Policy Editor, press Windows+R on your keyboard, type “gpedit.msc” into the Run dialog box, and press Enter.

see: https://www.howtogeek.com/howto/6229/how-to-use-bitlocker-on-drives-without-tpm/

## create_usb.sh

This bash script ERASES everything on a USB drive and:

- Creates a GUID partition table (GPT).
- Adds a single EFI Startup Partition (ESP) on it.
- Formats the ESP in FAT16 format.
- Copies the ".BEK" files from the "keys" folder (and subfolders) to the drive.

Demo:

![create_usb.sh screencast](create_usb.gif)

## Configure Bitlocker without TPM

To configure Bitlocker without TPM, follow these steps:

  - Open the Local Group Policy Editor by pressing Windows+R.
  - Type "gpedit.msc" into the Run dialog box, and press Enter.
  - Navigate to Local Computer Policy > Computer Configuration > Administrative Templates > Windows Components > BitLocker Drive Encryption > Operating System Drives in the left pane.
  - Double-click the "Require additional authentication at startup" option in the right pane.
  - Select "Enabled" at the top of the window, and ensure the "Allow BitLocker without a compatible TPM (requires a password or a startup key on a USB flash drive)" checkbox is enabled here.
  - Select "Disallow TPM" in the "Configure TPM Startup" dropdown field.
  - Click "OK" to save your changes.
  - You can now close the Group Policy Editor window.

Demo:

![gpedit screencast](gpedit.gif)
