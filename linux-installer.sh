#!/bin/bash

# Update packe for armhf
sudo dpkg --add-architecture armhf

# Update package lists
sudo apt update

# Install desired packages
sudo apt install -y apache2 mariadb-server mariadb-client php mosquitto build-essential git curl jq cmake libraspberrypi-dev raspberrypi-kernel-headers libc6:armhf  libstdc++6:armhf

# Install wget
wget -O - https://raw.githubusercontent.com/pjgpetecodes/dotnet8pi/main/install.sh | sudo bash
/home/kws/Downloads/dotnet-install.sh --version latest --runtime aspnetcore
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

sudo cp ConfigFiles/brbase_mosquitto.conf /etc/mosquitto/conf.d/
sudo cp ConfigFiles/TouchScreen.service /etc/systemd/system/
