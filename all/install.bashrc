#!/bin/bash -x

#if you want any feature just type anything in front of the variable

#are we installing inside of virtual box?
VBOX=

INSTALL_CHROME=
INSTALL_VSCODE=
INSTALL_TERM=
INSTALL_PUTTY=
INSTALL_WIRESHARK=
INSTALL_OPENVPN=

cd

# Google Chrome
if [[ -n $INSTALL_CHROME ]]
then
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
fi

# Git
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git -y

# For ifconfig
sudo apt install net-tools -y

# Setup environment
git clone https://github.com/mujicad93/configs.git
cp ~/configs/linux/example_ubuntu.bashrc ~/.bashrc
cp ~/configs/all/.gitconfig ~/
source ~/.bashrc

# Text Editors
sudo apt install vim -y
if [[ -n $INSTALL_VSCODE ]]
then
sudo snap install code --classic
echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
fi

# Clang Format
sudo apt install clang-format-6.0 -y

# Terminator
if [[ -n $INSTALL_TERM ]]
then
sudo apt-get install terminator -y
fi

# Putty
if [[ -n $INSTALL_PUTTY ]]
then
sudo apt install putty -y
sudo usermod -a -G dialout $USER
fi

# Wireshark
if [[ -n $INSTALL_WIRESHARK ]]
then
sudo apt-get install wireshark
sudo usermod -a -G wireshark $USER
fi

# OpenVPN
if [[ -n $INSTALL_OPENVPN ]]
then
sudo apt install openvpn -y
fi

if [[ -n $VBOX ]]
then
sudo adduser $USER vboxsf
fi

# better screenshot tool
sudo apt-get install flametool -y

sudo apt --fix-broken install
sudo apt-get install xclip -y

# creaty git ssh key
ssh-keygen -t rsa -b 4096 -C "andres.mujica@luminartech.com"
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub
echo "copy clipboard to github ssh key now"

