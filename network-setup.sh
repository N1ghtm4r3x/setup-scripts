#!/bin/bash
mkdir /scripts
wget -O /scripts/setup.sh https://raw.githubusercontent.com/N1ghtm4r3x/setup-scripts/main/setup.sh
chmod +x /scripts/setup.sh
ln /scripts/setup.sh /usr/bin/softinstall
read -p "Would you like to update the system?  (y/n): " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    apt-get update && apt-get upgrade -y && apt autopurge -y && apt autoclean -y
fi
rm /etc/network/interfaces
ip4=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
gateway=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
echo "auto eth0" > /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "    address "$ip4"/24"  >> /etc/network/interfaces
echo "    gateway "$gateway"" >> /etc/network/interfaces
echo "The following ipv4 address has been set: "$ip4""
echo "A reboot is required to finalize network settings, please run setup.sh afterwards"
read -p "Would you like to reboot? (y/n): " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
fi
