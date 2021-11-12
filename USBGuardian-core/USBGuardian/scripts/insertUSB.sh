#!/bin/bash

############################################################################################
# Auteurs : USBGuardian (code original v1.0), Raphaël "Nartekus" BOULANGER (modifications, #
#           corrections, debug, portabilité Raspberry Pi 4 model B, v2.x)                  #
# Version : v2.1                                                                           #
# Description : Ce script est lancé automatiquement lors de l'enfichage d'un périphérique  #
#               USB. C'est le premier script à être lancé, il vérifie si le périphérique   #
#               USB est partitionné et lance le montage adéquat en fonction de la réponse. #
#                                                                                          #
# Historique des modifications : 18/10/2021 --> v2 : Ajout des 3 echo à des fins de        #
#                                débuggage.                                                #
#                                12/11/2021 --> v2.1 : Ajout de ce cadre de commentaires.  #
############################################################################################

echo "insertUSB.sh Enter"
#Unmount usb stick in case there is an old one
sudo umount /mnt/usb

#Change directory
cd /opt/USBGuardian/logs

#Create the report file and write the date and the time in it
sudo truncate -s 0 report.log
sudo printf "Report created:  $(date)\n" >> ./report.log

#Check if the USB stick is partitioned
partitioned=1

while read x
do
	if [[ "$x" =~ ^sd[a-z][0-9] ]]; then
		partitioned="0"
	fi;
done << EOF
$(ls /dev)
EOF

#Mount the USB device depending on the number of partitions
if [ "$partitioned" = "0" ]; then
	sudo mount /dev/sd[a-z][0-9] /mnt/usb
	sudo printf "Partitioned: yes\n" >> ./report.log
else
	sudo mount /dev/sd[a-z] /mnt/usb
	sudo printf "Partitioned: no\n" >> ./report.log
fi;

#Create a file to store format info
sudo touch /opt/USBGuardian/scripts/checkFormat
sudo chmod +r+w /opt/USBGuardian/scripts/checkFormat


#Store format info about the key
sudo mount | grep /mnt/usb > /opt/USBGuardian/scripts/checkFormat

#Launch python script 
echo "insertUSB Exit"
echo "###"
sudo python3 /opt/USBGuardian/scripts/checkFormat.py

#If the format is supported start the scan
#if [ "$partitioned" = "0" ]; then
#	sudo python3 /opt/USBGuardian/scripts/scan.py
#fi
