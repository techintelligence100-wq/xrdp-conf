#!/bin/bash

# --- Color Codes for Formatting ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}===============================================${NC}"
echo -e "${BLUE}    Kali Linux XRDP Setup Script               ${NC}"
echo -e "${BLUE}===============================================${NC}"

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${YELLOW}Please run this script with sudo or as root:${NC}"
  echo "sudo bash $0"
  exit 1
fi

echo -e "\n${YELLOW}[*] Step 1: Updating packages and installing XRDP + Xfce...${NC}"
apt update
apt install xrdp kali-desktop-xfce xfce4 xfce4-goodies -y

echo -e "\n${YELLOW}[*] Step 2: Configuring XRDP service...${NC}"
systemctl enable xrdp
systemctl start xrdp

# Add xrdp user to ssl-cert group
adduser xrdp ssl-cert

# Configure default session for the user who ran sudo
TARGET_USER=${SUDO_USER:-$USER}
USER_HOME=$(eval echo ~$TARGET_USER)

echo "xfce4-session" > "$USER_HOME/.xsession"
chown $TARGET_USER:$TARGET_USER "$USER_HOME/.xsession"

echo -e "\n${YELLOW}[*] Step 3: Restarting XRDP service to apply changes...${NC}"
systemctl restart xrdp

echo -e "\n${GREEN}[+] Setup complete!${NC}"
echo -e "${BLUE}===============================================${NC}"
echo -e "${GREEN}Your Kali Linux IP Address(es):${NC}"
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1'
echo -e "${BLUE}===============================================${NC}"
echo -e "You can now connect using Windows Remote Desktop (mstsc) or Remmina."
echo -e "${YELLOW}Note: Make sure to log out of your local graphical session before connecting via RDP!${NC}"
