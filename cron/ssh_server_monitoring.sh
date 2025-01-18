#!/bin/bash

log_file="./../logs/ssh_server_monitoring.log" 

echo -e "\n========== CHECK SSH STATUS ==========" > "$log_file"
ssh_status=$(systemctl status ssh | grep "Active: ") 
echo -e "$ssh_status" | tee -a "$log_file"

if [[ $ssh_status == *"inactive"* ]]; then
	echo -e "\n========== RESTARTING SSH SERVICE ==========" | tee -a "$log_file"
	systemctl restart ssh
fi

echo -e "\n========== USER & IP ADDRESS =========="
hostname | tee -a "$log_file"
hostname -I | tee -a "$log_file"
