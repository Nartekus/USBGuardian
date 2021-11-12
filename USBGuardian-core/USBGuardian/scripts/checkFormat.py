#!/usr/bin/python3.5
#-*- coding: utf-8 -*-

############################################################################################
# Auteurs : USBGuardian (code original v1.0), Raphaël "Nartekus" BOULANGER (modifications, #
#           corrections, debug, portabilité Raspberry Pi 4 model B, v2.0)                  #
# Version : v2.1                                                                           #
# Description : Ce sript ouvre un fichier qui est édité par un autre script. Son but est   #
#               d'y lire le format du périphérique USB et de l'inclure dans le fichier     #
#               de logs "report.log". C'est ce script qui vérifie que le format du         #
#               périphérique USB est bien supporté par l'outil et qui amorce le scan en    #
#               lançant le script "scan.py" le cas échéant.                                #
#                                                                                          #
# Historique des modifications : 18/10/2021 --> v2 : Ajout des 3 print avant le            #
#                                lancement du script "scan.py" à des fins de débuggage.    #
#                                12/11/2021 --> v2.1 : Ajout de ce cadre de commentaires.  #
############################################################################################

import os

print("checkFormat.py Enter")
#Open the file in which format info is stored
checkFormat = open('/opt/USBGuardian/scripts/checkFormat',"r")
formatOK=0

#Read the file to search the format
for lignes in checkFormat:

	if "vfat" in lignes:
		format="VFAT"

	elif "fat32" in lignes:
		format="FAT32"

	elif "fat16" in lignes:
		format = "FAT16"

	else:
		format="Unsupported format"
		formatOK=1

#Write the format in the report
with open('/opt/USBGuardian/logs/report.log',"a") as report:
	report.write("USB stick format: " + format+"\n")

#Delete the checkFormat file
os.system("sudo rm /opt/USBGuardian/scripts/checkFormat")

#Execute the scan
if formatOK==0:
	print("checkFormat OK")
	print("checkFormat Exit")
	print("###")
	os.system("sudo python3 /opt/USBGuardian/scripts/scan.py")

