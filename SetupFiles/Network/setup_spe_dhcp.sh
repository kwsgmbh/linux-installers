#!/bin/bash

# Check if the script is running with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script requires root privileges. Please run it with sudo."
    exit 1
fi

sudo nmcli connection modify spe0 ipv4.method shared ipv4.addresses 192.168.1.1/24
sudo nmcli connection up spe0



