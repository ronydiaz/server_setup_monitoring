#!/bin/bash

# Defining log file
log_file="./logs/serverconfig_installation_log.txt"

# Updating packages
echo -e "========== UPDATING PACKAGES ==========" | tee -a "$log_file"
sudo apt update 2> /dev/null | tee -a "$log_file" 
sudo apt upgrade -y 2> /dev/null 2>&1 | tee -a "$log_file"

# Installing SSH server package
echo -e "\n========== INSTALLING SSH SERVER ==========" | tee -a "$log_file"
sudo apt-get install -y openssh-server | tee -a "$log_file"

echo -e "\n========== ENABLE SSH SERVICE ==========" | tee -a "$log_file"
sudo systemctl enable ssh
sudo systemctl start ssh

echo -e "\n========== CHECK SSH STATUS ==========" | tee -a "$log_file"
ssh_status=$(systemctl status ssh | grep "Active: ") 
echo "$ssh_status" | tee -a "$log_file"

if [[ $ssh_status == *"inactive"* ]]; then
	echo -e "\n========== RESTARTING SSH SERVICE ==========" | tee -a "$log_file"
	systemctl restart ssh
fi

echo -e "\n========== USER & IP ADDRESS ==========" | tee -a "$log_file"
echo -n "$(hostname)@$(hostname -I | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | awk '{print $1}')" | tee -a "$log_file"
