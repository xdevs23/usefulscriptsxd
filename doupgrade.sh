#!/bin/bash

echo -en "\n"
sudo -p "Type in your password:" whoami>/dev/null
echo -en "\033[1A"
sleep 1
echo -en "Updating package list..."
sudo apt-get update | grep "E:"
echo -en "\rUpdating packages...\n"
sudo apt-get upgrade -y
echo "Checking for missing dependencies..."
sudo apt-get install --fix-missing -y
echo "Checking for distribution upgrade..."
sudo apt-get dist-upgrade -y
echo "Fixing missing dependencies..."
sudo apt-get -f install
echo "Autocleaning..."
sudo apt-get autoclean -y
sudo apt-get autoremove -y
echo "Finished!"
