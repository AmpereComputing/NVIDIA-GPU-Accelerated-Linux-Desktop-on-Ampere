#!/bin/bash

sudo rmmod nouveau
cat << EOF | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF

sudo update-initramfs -u -k all
sudo apt install -y dkms
# Change the dirver package to the downloaded one
sudo sh ./NVIDIA-Linux-aarch64-xxx.run
# Let the installer update x-config file
sudo nvidia-xconfig -a --cool-bits=31 --allow-empty-initial-configuration
$ sudo reboot
# check GPU drivers
# nvidia-smi 
