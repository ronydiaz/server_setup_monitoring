#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Colors for output
green="\e[32m"
reset="\e[0m"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${green}Please run as root or use sudo.${reset}"
    exit 1
fi

echo -e "${green}Updating package lists...${reset}"
apt update -y
apt upgrade -y

# Install dependencies
echo -e "${green}Installing required dependencies...${reset}"
apt install -y ca-certificates curl gnupg

# Add Docker's GPG key
echo -e "${green}Adding Docker's official GPG key...${reset}"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null
chmod a+r /etc/apt/keyrings/docker.asc

# Remove any incorrect Docker repositories
echo -e "${green}Checking for incorrect Docker repositories...${reset}"
if grep -q "download.docker.com/linux/ubuntu" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
    echo -e "${green}Removing incorrect Ubuntu repository...${reset}"
    rm -f /etc/apt/sources.list.d/docker.list
fi

# Add correct Docker repository for Debian
echo -e "${green}Adding Docker repository...${reset}"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again
echo -e "${green}Updating package lists with Docker repo...${reset}"
apt update -y

# Install Docker
echo -e "${green}Installing Docker...${reset}"
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker service
echo -e "${green}Enabling and starting Docker service...${reset}"
systemctl enable --now docker

# Add current user to Docker group to avoid using sudo every time
echo -e "${green}Adding user $USER to Docker group...${reset}"
usermod -aG docker $USER

# Notify user to log out and back in
echo -e "${green}Installation complete! Please log out and log back in for changes to take effect.${reset}"

docker --version
docker run hello-world

