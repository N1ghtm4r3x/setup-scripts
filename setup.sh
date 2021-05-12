#!/bin/bash
# Bash Menu Script Example
ip4=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
PS3='Please select the software you would like to install (please press enter to see the menu again): '
options=("Adguard" "Wireguard" "Docker" "Quit")
select opt in "${options[@]}"
do
    case $opt in
       "Adguard")
            echo "==========================================="
            echo "= Installing Adguard & required packages. ="
            echo "==========================================="
            mkdir /adguard
            wget -O /adguard/adguard.tar.gz https://static.adguard.com/adguardhome/release/AdGuardHome_linux_armv6.tar.gz && tar xzf /adguard/adguard.tar.gz            
            ln /adguard/AdGuardHome/AdGuardHome /usr/bin/adguard
            adguard -s install
            echo "================================================="
            echo "= Please open "$ip4":3000 and follow the steps. ="
            echo "================================================="
            ;;
        "Wireguard")
            echo "===================================================================================================="
            echo "= Installing wireguard & required packages, please use default port or write the custom port down. ="
            echo "===================================================================================================="
            wget https://git.io/wireguard -O wireguard-install.sh && bash wireguard-install.sh            
            mv wireguard-install.sh /scripts
            chmod +x /scripts/wireguard-install.sh
            ln /scripts/wireguard-install.sh /usr/bin/wgadd
            echo "============================================================================="
            echo "= Please run wgadd to add more or remove existing clients.                  ="
            echo "============================================================================="
            echo "======================================================================================="
            echo "= Please do not forget to forward port 51820 or the port that you specified to "$ip4" ="
            echo "======================================================================================="
            ;;
        "Docker")
            echo "===================================="
            echo "= Installing docker and yacht.     ="
            echo "===================================="
            apt-get install curl -y -q
            curl -fsSL https://get.docker.com -o get-docker.sh
            docker volume create yacht
            docker run -d -p 8000:8000 -v /var/run/docker.sock:/var/run/docker.sock -v yacht:/config selfhostedpro/yacht
            echo "===================================="
            echo "= Yacht can be found on port 8000. ="
            echo "===================================="
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
