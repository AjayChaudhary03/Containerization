#!/bin/bash

#   **********************************************************  #
#   #Author :   Ajay Chaudhary
#   #Date   :   03/08/2025
#   #Purpose:   Uninstall Jenkins from Ubuntu
#   **********************************************************  #

set -x

#   1. Stop the Jenkins Service
sudo systemctl stop jenkins

#   2.  Remove the Jenkins Package
sudo apt-get remove --purge jenkins

#   3. Remove Jenkins Dependencies
sudo apt-get autoremove

#   4. Delete Jenkins User and Group (Optional)
sudo deluser jenkins
sudo delgroup jenkins

# 5. Remove Jenkins Directories (Optional)
sudo rm -rf /var/lib/jenkins
sudo rm -rf /var/log/jenkins
sudo rm -rf /etc/jenkins

