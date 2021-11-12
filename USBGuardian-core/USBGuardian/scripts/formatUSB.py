#!/usr/bin/python3.5
#-*- coding:utf-8 -*-

############################################################################################
# Auteurs : USBGuardian (code original v1.0), Raphaël "Nartekus" BOULANGER (modifications, #
#           corrections, debug, portabilité Raspberry Pi 4 model B, v2.0)                  #
# Version : v2.0                                                                           #
# Description : Ce script permet le formatage du périphérique USB en fonction de s'il est  #
#               partionné et le cas échéant de son format. Actuellement ce script ne peut  #
#               pas être appelé, la fonction d'appel a été volontairement désactivé à des  #
#               fins de tests.                                                             #
#                                                                                          #
# Historique des modifications : 18/10/2021 --> v2.0 : Ajout des 3 print à des fins de     #
#                                débuggage.                                                #
#                                12/11/2021 --> v2.1 : Ajout de ce cadre de commentaires.  #
############################################################################################

import os

print("format.py Enter")
#Unmount the USB stick
os.system("sudo umount /mnt/usb")

#Open the report file
with open("/opt/USBGuardian/logs/report.log") as report:

	for line in report:

		#If the USB stick is not partitioned, create a partition and format it
		if "Partitioned: no" in line:
			os.system("echo ',,7;' | sfdisk /dev/sd[a-z]")
			os.system("mkfs.vfat -I /dev/sd[a-z][0-9]")
			break

		#If the USB stick is partitioned, format the  USB stick depending  on the format
		elif "FAT16" in line:
			os.system("sudo mkfs.fat -F 16 -I /dev/sd[a-z][0-9]")
			break

		elif "FAT32" in line:
			os.system("sudo mkfs.fat -F 32 -I /dev/sd[a-z][0-9]")
			break

		elif "VFAT" in line:
			os.system("sudo mkfs.vfat -I /dev/sd[a-z][0-9]")
			break

print("format.py Exit")
print("###")
