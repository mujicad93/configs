#!/bin/bash -x

cd

# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Git
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
sudo snap install code --classic

# Clang Format
sudo apt install clang-format-5.0 -y

# Terminator
sudo apt-get install terminator -y

# Putty
sudo apt install putty -y
sudo usermod -a -G dialout $USER
cp ~/configs/all/.putty ~/

# cmake
sudo apt install cmake -y
#sudo apt-get install libboost-all-dev -y

# Wireshark
sudo apt-get install wireshark
$ sudo dpkg-reconfigure wireshark-common
$ sudo usermod -a -G wireshark $USER

# OpenVPN
sudo apt install openvpn -y

# Mac changer
sudo apt install macchanger -y

#sudo adduser $USER vboxsf

# Xilinx install drivers
# cd /opt/Xilinx/Vivado/2019.1/data/xicom/cable_drivers/lin64/install_script/install_drivers
# sudo ./install_drivers

sudo apt --fix-broken install

# creaty git ssh key
ssh-keygen -t rsa -b 4096 -C "andres.mujica@luminartech.com"
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
sudo apt-get install xclip -y
xclip -sel clip < ~/.ssh/id_rsa.pub
echo "copy clipboard to github ssh key now"

