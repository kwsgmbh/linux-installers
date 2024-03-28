#!/bin/bash

# Check if the script is running with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script requires root privileges. Please run it with sudo."
    exit 1
fi

product=$(tr -d '\0' < /proc/device-tree/hat/product)
product="${product//\'/\"}"
modified_product=$(echo "$product" | jq '.DSN')
modified_product=$(echo "$modified_product" | tr -d '"')
echo "BridgEth-Base_$modified_product"

# Commands requiring root privileges
sudo nmcli dev wifi hotspot ifname wlan0 ssid "BridgEth-Base_$modified_product" password "12345678"

