#!/bin/bash

# Check if the script is running with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script requires root privileges. Please run it with sudo."
    exit 1
fi

product=$(tr -d '\0' < /proc/device-tree/hat/product)
product="${product//\'/\"}"
echo Setup MAC-Addr
modified_product1=$(echo "$product" | jq '.MAC1')
modified_product1=$(echo "$modified_product1" | tr -d '"')
modified_product1=$(sed 's/../&:/g; s/:$//' <<< "$modified_product1")
echo MAC1: "$modified_product1"
modified_product2=$(echo "$product" | jq '.MAC2')
modified_product2=$(echo "$modified_product2" | tr -d '"')
modified_product2=$(sed 's/../&:/g; s/:$//' <<< "$modified_product2")
echo MAC2: "$modified_product2"
modified_product3=$(echo "$product" | jq '.MAC3')
modified_product3=$(echo "$modified_product3" | tr -d '"')
modified_product3=$(sed 's/../&:/g; s/:$//' <<< "$modified_product3")
echo MAC3: "$modified_product3"

# Commands requiring root privileges
sudo nmcli connection modify 'Wired connection 1' connection.id eth0
sudo nmcli connection modify eth0 ifname eth0
sudo nmcli con mod eth0 ethernet.cloned-mac-address "$modified_product1"

sudo nmcli connection modify 'Wired connection 2' connection.id eth1
sudo nmcli connection modify eth1 ifname eth1
sudo nmcli con mod eth1 ethernet.cloned-mac-address "$modified_product2"

sudo nmcli connection modify 'Wired connection 3' connection.id spe0
sudo nmcli connection modify spe0 ifname eth2
sudo nmcli con mod spe0 ethernet.cloned-mac-address "$modified_product3"

sudo nmcli connection up eth1
sudo nmcli connection up spe0
sudo nmcli connection up eth0

