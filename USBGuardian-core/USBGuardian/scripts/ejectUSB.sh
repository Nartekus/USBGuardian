#!/bin/bash
echo "ejectUSB.sh Enter"
#Save what was mounted
mounted=$(sudo mount | grep /mnt/usb | awk -F " " '{print $1}')

#Unmount the USB stick
sudo umount /mnt/usb

#Eject the USB stick
sudo eject $mounted

#Kill any clamscan running (if USB stick is removed before the end of analysis
sudo killall clamscan

#Empty the report of the current USB stick
sudo truncate -s 0 /opt/USBGuardian/logs/report.log
echo "ejectUSB.sh Exit"
echo "###"
