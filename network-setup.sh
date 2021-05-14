#!/bin/bash
mkdir /scripts
wget -O /scripts/setup.sh https://raw.githubusercontent.com/N1ghtm4r3x/setup-scripts/main/setup.sh
chmod +x /scripts/setup.sh
ln /scripts/setup.sh /usr/bin/softinstall
if ! which route > /dev/null; then
      sudo apt-get install net-tools -y -qq
fi
read -p "Would you like to update the system?  (y/n): " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    apt-get update && apt-get upgrade -y && apt autopurge -y && apt autoclean -y
fi
rm /etc/network/interfaces
nic=$(route | grep '^default' | grep -o '[^ ]*$')
ip4=$(ip -4 addr show "$nic" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
gateway=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
echo "auto "$nic"" > /etc/network/interfaces
echo "iface "$nic" inet static" >> /etc/network/interfaces
echo "    address "$ip4"/24"  >> /etc/network/interfaces
echo "    gateway "$gateway"" >> /etc/network/interfaces
echo "The following ipv4 address has been set: "$ip4""
echo "A reboot is required to finalize network settings, please run setup.sh afterwards"
read -p "Would you like to reboot? (y/n): " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
fi