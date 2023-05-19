#!/bin/bash

sudo add-apt-repository ppa:flatpak/stable
sudo apt update
sudo apt install flatpak
# Install Flatpak Plugin
sudo apt install gnome-software-plugin-flatpak
# Add Flatpak Repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo