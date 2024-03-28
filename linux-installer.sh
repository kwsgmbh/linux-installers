#!/bin/bash

# Update package lists
sudo apt update

# Install desired packages
sudo apt install -y apache2 mariadb-server mariadb-client php mosquitto build-essential git curl jq

# Install wget
wget https://dot.net/v1/dotnet-install.sh -O /home/kws/Downloads/dotnet-install.sh
chmod +x /home/kws/Downloads/dotnet-install.sh
/home/kws/Downloads/dotnet-install.sh --version latest --runtime aspnetcore
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

sudo cp ConfigFiles/brbase_mosquitto.conf /etc/mosquitto/conf.d/
sudo cp ConfigFiles/TouchScreen.service /etc/systemd/system/
