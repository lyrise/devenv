#!bin/zsh

# dotnet
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
add-apt-repository universe
apt update
apt install apt-transport-https
apt update
apt install dotnet-sdk-3.1

# rust
curl https://sh.rustup.rs -sSf | sh -s -- -q -y

# goenv
git clone https://github.com/syndbg/goenv.git $HOME/.goenv

# zplug
git clone https://github.com/zplug/zplug $HOME/.zplug
