# Bitlocker and LUKS tools

The power of full disk encryption lies in that it is easy to understand and reason about. A key file on a USB drive is such a simple solution for which you can find tools and instructions in this repository.

## create_usb.sh

This bash script ERASES everything on a USB drive and:

- Creates a GUID partition table (GPT).
- Adds a single EFI Startup Partition (ESP) on it.
- Formats the ESP in FAT16 format.
- Copies the ".BEK" files from the "keys" folder (and subfolders) to the drive.
- Copies the ".lek" files from the "keys" folder (and subfolders) to the drive.

Demo:

![create_usb.sh screencast](create_usb.gif)

## Windows 10 Pro - Bitlocker

On Windows the Trusted Platform Module (TPM) will hold your disk encryption keys and bind your disk to your motherboard. This TPM might get wiped on BIOS updates (especially on AMD where the TPM is virtual). You can avoid all this trouble this by disabling TPM in your computer's BIOS. If you do this then your disk is encrypted by the key file or passphrase (as expected). 

Read more: https://tqdev.com/2021-why-i-use-bitlocker-without-tpm

### Configure Bitlocker without TPM

To configure Bitlocker without TPM, follow these steps:

  - Disable TPM in your BIOS (very important!)
  - Open the Local Group Policy Editor by pressing Windows+R.
  - Type "gpedit.msc" into the Run dialog box, and press Enter.
  - Navigate to Local Computer Policy > Computer Configuration > Administrative Templates > Windows Components > BitLocker Drive Encryption > Operating System Drives in the left pane.
  - Double-click the "Require additional authentication at startup" option in the right pane.
  - Select "Enabled" at the top of the window, and ensure the "Allow BitLocker without a compatible TPM (requires a password or a startup key on a USB flash drive)" checkbox is enabled here.
  - Click "OK" to save your changes.
  - You can now close the Group Policy Editor window.
  - Enable BitLocker and choose to use a startup key on a USB flash drive (BEK file).

source: https://www.howtogeek.com/howto/6229/how-to-use-bitlocker-on-drives-without-tpm/

## Ubuntu - LUKS

On Linux the TPM is not used. The key file or passphrase is actually used to encrypt the drive (as expected).

### Configure LUKS

During the installation of Ubuntu you can choose to use LVM and encrypt the entire disk. During the installation you need to choose a passphrase. 

### generate_key.sh

This bash script creates keys for a LUKS enabled machine.

- It generates a new UUID based key file.
- It generates a new recovery key (passphrase).
- It creates a bash script to install the LUKS keys.

After installing and testing the newly added keys you may remove the initial passphrase (entered during installation) from slot 0.
