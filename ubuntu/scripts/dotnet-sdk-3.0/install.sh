#! /bin/bash
# https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-current

sudo apt update
sudo apt -y install wget

# Make tmp directory
mkdir tmp

wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O tmp/packages-microsoft-prod.deb
sudo dpkg -i tmp/packages-microsoft-prod.deb

sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-3.0

# Delete tmp directory
sudo rm -rf tmp
