#!/bin/bash
echo "reboot.sh Enter"
#Empty the log files
sudo truncate -s 0 /opt/USBGuardian/logs/report.log
sudo truncate -s 0 /opt/USBGuardian/logs/lastAnalysis.log
# Reboot the Raspberry
#sudo reboot
echo "reboot.sh Exit"
echo "###"
