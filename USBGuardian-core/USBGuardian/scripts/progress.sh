#!/bin/bash

############################################################################################
# Auteurs : USBGuardian (code original v1.0), Raphaël "Nartekus" BOULANGER (modifications, #
#           corrections, debug, portabilité Raspberry Pi 4 model B, v2.0)                  #
# Version : v2.1                                                                           #
# Description : Ce script gère le background de la barre de progression statuant sur       #
#               l'état d'avancement du scan actuel. Par calcul, en fonction du nombre de   #
#               fichiers dans le périphérique USB et en fonction de l'avancement de        #
#               l'analyse, la barre de progression avancera plus ou moins vite. Avec pour  #
#               constante les 25 premiers pourcents servants d'initialisation de notre     #
#               Antivirus.                                                                 #
#                                                                                          #
# Historique des modifications : 18/10/2021 --> v2.0 : Ajout des 3 echo à des fins de      #
#                                débuggage.                                                #
#                                12/11/2021 --> v2.1 : Ajout de ce cadre de commentaires.  #
############################################################################################

echo "progress.sh Enter"
# Go to mounted usb  
cd /mnt/usb/
percentage=0
sDuration=2.4

# Get the total number of files in the mounted usb device
total=$(find . -type f | wc -l)

# Start listening to clamav scan progress
while true
do
	# Refresh total number of files in the mounted usb device
	totalRealTime=$(find . -type f | wc -l)
	# Get the number of files scanned by clamscan
	current=$(grep -o "OK\|FOUND\|Empty\|ERROR" /opt/USBGuardian/logs/lastAnalysis.log | wc -l)
	# Get the number of files removed by clamscan if any
	filesRemoved=$(grep -o "Removed" /opt/USBGuardian/logs/lastAnalysis.log | wc -l)
	# Substract the number of removed files to the current number of files
	current=$((current - filesRemoved))
	totalR=$((total - filesRemoved))
	if [ "$totalRealTime" -lt "$totalR" ]
	then
		echo "USB Removed"
		#Stop the clamscam process
		sudo killall clamscan
		exit
	fi

	# The first 25% will be dedicated for clamav libs to be loaded
	if [ "$percentage" -lt 25 ]
	then
		# Since the sleep is set to 2.4 sec, it will take 60 sec to reach 25%
		percentage=$((percentage + 1))
	fi
	if [ "$percentage" -gt 24 ]
	then
		# Convert the number of files scanned to percentage on 75% total scale
		current=$((current * 75))
		percentage=$((current / totalRealTime))
		# Add the 25% progress previously loaded for clamav libs
		percentage=$((percentage + 25))
		# Set the sleep duration in order to print progress every 0.125sec
		sDuration=0.125
	fi

	echo "$percentage %"

	if [ "$percentage" -gt 99 ]
	then
		exit
	fi
	# Slow down the speed of listening
	sleep "$sDuration"
done

echo "progress.sh Exit"
echo "###"
