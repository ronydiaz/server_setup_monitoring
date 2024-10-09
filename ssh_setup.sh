#!/bin/bash

# Defininf log file
log_file="ssh_serverconfig.txt"

# Updating packages
echo -e "========== UPDATING PACKAGES ==========" | tee -a "$log_file"
sudo apt update 2> /dev/null | tee -a "$log_file" 
sudo apt upgrade -y > /dev/null 2>&1 | tee -a "$log_file"

# Installing SSH server package
echo -e "\n========== INSTALLING SSH SERVER =========="
sudo apt-get install -y openssh-server | tee -a "$log_file"

echo -e "\n========== CHECK SSH STATUS ==========" 
systemctl status ssh | grep "Active: "
