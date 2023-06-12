#!/bin/bash

flatpak install flathub org.dhewm3.Dhewm3

# https://dhewm3.org/#how-to-install
# Download and Install Doom3 Demo Package
wget https://files.holarse-linuxgaming.de/native/Spiele/Doom%203/Demo/doom3-linux-1.1.1286-demo.x86.run
sh doom3-linux-1.1.1286-demo.x86.run --tar xf demo/
mkdir ~/.var/app/org.dhewm3.Dhewm3/data/dhewm3
mkdir ~/.var/app/org.dhewm3.Dhewm3/data/dhewm3/base
cp demo/demo00.pk4 ~/.var/app/org.dhewm3.Dhewm3/data/dhewm3/base
# The demo data can also be used command line without copying to base folder.
#sudo dhewm3 +set fs_basepath /home/HansWerner/Games/doom3