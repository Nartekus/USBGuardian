#!/bin/bash

############################################################################################
# Auteurs : USBGuardian (code original v1.0), Raphaël "Nartekus" BOULANGER (modifications, #
#           corrections, debug, portabilité Raspberry Pi 4 model B, v2.0)                  #
# Version : v2.2                                                                           #
# Description : Ce script permet d'éjecter le périphérique USB propremement et de remettre #
#               à zéro le fichier de logs, servant de base de travail temps réél, pour le  #
#               prochain périphérique USB.                                                 #
#                                                                                          #
# Historique des modifications : 18/10/2021 --> v2 : Ajout de l'echo en début de script et #
#                                des 2 echos en fin de script à des fins de débuggage.     #
#                                           --> v2.1 : Ajout de la fonction de sauvegarde  #
#                                de ce qui a été monté et de l'éjection.                   #
#                                12/11/2021 --> v2.2 : Ajout de ce cadre de commentaires.  #
############################################################################################

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
