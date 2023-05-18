![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# GPU Accelerated Linux Desktop on Ampere

## Summary

This repo contains scripts and documents to assit in the installation of Windows on Ampere Platforms.

## Table of Contents
* [Introduction](#introduction)
* [Requirements](#requirements)
  * [Hardware](#hardware)
  * [Operating System](#operating-system)
* [Install Windows 11 via ISO](#install-windows-via-iso)
  * [Create UUP Dump File for Windows 11](#create-uup-dump-file-for-windows-11)
  * [Building Windows 11 ISO on Ampere Platform](#build-windows-11-iso-on-ampere-platform)
  * [Create Bootable USB for Windows 11 with Rufus](create-bootable-usb-for-windows-11-with-rufus)
  * [Install Windows on Ampere Workstation](install-windows-on-ampere-workstation)
* TODO Applications supported
* TODO Application Development
* [References](#references)


## Hardware Environment
AADP A1 has bug on grub and **A2** version is recommended.

### Monitors connected to builtin VGA
One monitor can connect to builtin VGA output is required on setup process.

### Monitors connected to GPU video
Although it can run with only one monitor attached to GPU video output, but the booting processes information will not be able to show on the monitor attached to GPU. 

### Recommended Nvidia GPUs
Nvidia RTX series GPU with one or more displayport and/or HDMI video output are recommended.


### Install Nvidia GPU
Install GPU at one of the two PCIex16 slots and connect power cables if needed.

### GPU power connectors
The box comes with a spare GPU power cable hidden at the back of motherboard. 

## Software Environment
- Ubuntu 20.04 or 22.04 server
- Nvidia GPU driver
- Desktop environment

## Installation Guide
### Install Ubuntu 20.04 or 22.04 with USB
1. Download Ubuntu 22.04 server. 
1. Install ubuntu with HWE

### Install GPU driver
[Download](https://www.nvidia.com/Download/driverResults.aspx/204838/en-us/) and install GPU driver 
```
$ sudo nano /etc/default/grub
# Add pcie_aspm=off to kernel parameters
# GRUB_CMDLINE_LINUX_DEFAULT="pcie_aspm=off"
# and update grub
$ sudo update-grub
$ sudo reboot

$ sudo rmmod nouveau
$ cat << EOF | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF

$ sudo update-initramfs -u -k all
$ sudo apt install -y dkms
$ sudo sh ./NVIDIA-Linux-aarch64-xxx.run
# Let the installer update x-config file
$ sudo reboot
# check GPU drivers
# nvidia-smi 
```
### Install Desktop environment 
```
$ sudo apt install ubuntu-desktop
```
Enable GPU accelerated desktop
```
$ sudo nvidia-xconfig -a --cool-bits=31 --allow-empty-initial-configuration
```
## Set up Audio
Mic/Speaker on the top of the case - A1 is not working. A2 is working
HDMI/DisplayPort Audio - recommended for audio via TV speaker. Both audio via HDMI and DisplayPort works. 

Digital Output - No physical link/plug found

## Verify GPU accelerated desktop
Install glmark2 
```
sudo apt install glmark2
glmark2
# Check the render is Nvidia not LLVM
```

## Multiple monitors 
On the desktop GUI, start Settings->Displays, and then adjust the display settings and adjust the relative position of the displays.

### Install Nvidia GPU Accelerated Linux Desktop
This repo contains scripts and documents to enable Nvidia GPU accelerated desktop on Ampere CPU based workstation. It also demonstrated on installing desktop applications like open source DOOM3. 
### Install Ubuntu Desktop
This [document](Install_Ubuntu_Desktop.md) has more details on how to install Ubuntu desktop.
### Install Flatpack and Open Source DOOM3 Demo
This [document](Install_Flatpak_Dhewm3.md) has more details on how to install flatpak and running open source version of DOOM3.

## Install Flatpak

[Flatpak](https://flatpak.org/) collected a lots of applications that supports both amd64 and Aarch64/Arm64. On Ubuntu, it can be installed with the follow commands.
```
sudo add-apt-repository ppa:flatpak/stable
sudo apt update
sudo apt install flatpak
```
### Install Flatpak plugin
```
sudo apt install gnome-software-plugin-flatpak
```
**Note**: Installing applications from GUI might be broken.

### Add Flatpak repository

```
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```
### Date/Time issue
If any of the commands above failed, it might be date/time issue. Use the following commands to update the system time and re-run the commands again. 
```
sudo apt install ntp
sudo systemctl restart ntp
```

## Install Dhewm3 - open source version of DOOM3  
### Install the application
```
flatpak install flathub org.dhewm3.Dhewm3
```
### Download and install Doom3 demo package
```
wget https://files.holarse-linuxgaming.de/native/Spiele/Doom%203/Demo/doom3-linux-1.1.1286-demo.x86.run
sh doom3-linux-1.1.1286-demo.x86.run --tar xf demo/
mkdir .var/app/org.dhewm3.Dhewm3/data/dhewm3
mkdir .var/app/org.dhewm3.Dhewm3/data/dhewm3/base
cp demo/demo00.pk4 .var/app/org.dhewm3.Dhewm3/data/dhewm3/base
```

**Note**: The demo data can also be used command line without copying to base folder.
```
dhewm3 +set fs_basepath /home/HansWerner/Games/doom3
```
Reference: [dhewm3 - Doom3 Source Port](https://dhewm3.org/#how-to-install)

### Run DOOM3
```
flatpak run org.dhewm3.Dhewm3
#Run doom3 in full screen
flatpak run org.dhewm3.Dhewm3 +set r_fullscreen 1
```

**Note**: With more than one monitors, the game windowed could be anywhere, while the fullscreen game  will be on the primary window. 

Please refer to Enable Nvidia GPU accelerated Ubuntu Desktop to set up primary window.

For more startup parameters, check this [document](https://modwiki.dhewm3.org/Startup_parameters).
