#!/bin/bash

############################################################################################
# Auteurs : USBGuardian (code original v1.0), Raphaël "Nartekus" BOULANGER (modifications, #
#           corrections, debug, portabilité Raspberry Pi 4 model B, v2.0)                  #
# Version : v2.1                                                                           #
# Description : Ce script vide les fichiers de logs qui sont utilisés en temps réél pour   #
#               les fonctions de l'outil et il lance le reboot hardware de la machine.     #
#                                                                                          #
# Historique des modifications : 18/10/2021 --> v2.0 : Ajout des 3 echo à  des fins de     #
#                                débuggage.                                                #
#                                12/11/2021 --> v2.1 : Ajout de ce cadre de commentaires.  #
############################################################################################

echo "reboot.sh Enter"
#Empty the log files
sudo truncate -s 0 /opt/USBGuardian/logs/report.log
sudo truncate -s 0 /opt/USBGuardian/logs/lastAnalysis.log
# Reboot the Raspberry
sudo reboot
echo "reboot.sh Exit"
echo "###"
