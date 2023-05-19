![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# GPU Accelerated Linux Desktop on Ampere

## Summary

This repo contains scripts and documents to assit in the installation of Windows on Ampere Platforms.

## Table of Contents
* [Introduction](#introduction)
* [Requirements](#requirements)
  * [Hardware](#hardware)
  * [Operating System](#operating-system)
* [Hardware Environment](#hardware-environment)
  * [Monitors Connected to Builtin VGA](#monitors-connected-to-builtin-vga)
  * [Monitors Cconnected to GPU Video](#monitors-connected-to-gpu-video-output)
  * [Install Nvidia GPU](#install-nvidia-gpu)
  * [GPU power Connectors](#gpu-power-connectors)
* [Installation Guide](#installation-guide)
  * [Install Ubuntu 20.04 or 22.04 with USB](#install-ubuntu-2004-or-2204-with-usb)
  * [Install GPU driver](#install-gpu-driver)
  * [Install Desktop environment](#install-desktop-environment)
  * [Set up Audio](#set-up-audio)
  * [Verify GPU accelerated desktop](#verify-gpu-accelerated-desktop)
  * [Setup Multiple Monitors](#setup-multiple-monitors)
  * [Share Desktop Remotely](#share-desktop-remotely)
* Applications
  * [Install Flatpak](#install-flatpak)
  * [Install Dhewm3 - Open Source Version of DOOM3]
  * Paraview
  * Yolov8
  * HPC
* Application Development
  * Electron
  * VS Code
  * Flutter
  * Android Studio
  * Jetson 
* [References](#references)

## Introduction
## Requirement
### Hardware
* An Ampere CPU based workstation to be installed Linux Desktop
  * AADP[^1]
* One or more Nvidia RTX GPU
  * RTX 2060, 3060/3070, 4080/4090, A4500 
  * Optional: NVLINK

### Software 
1.  Ubuntu 20.04 or 22.04 server for arm64
1. Nvidia GPU driver

## Hardware Environment
AADP A1 has bug on grub and **A2** version is recommended.

### Monitors Connected to Builtin VGA
One monitor can connect to builtin VGA output is required on setup process.

### Monitors Connected to GPU Video Output
Although it can run with only one monitor attached to GPU video output, but the booting processes information will not be able to show on the monitor attached to GPU. 

### Install Nvidia GPU
Install GPU at one of the two PCIex16 slots and connect power cables if needed.

### GPU Power Connectors
The box comes with a spare GPU power cable hidden at the back of motherboard. 

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
### Install Desktop Environment 
```
$ sudo apt install ubuntu-desktop
```
Enable GPU accelerated desktop
```
$ sudo nvidia-xconfig -a --cool-bits=31 --allow-empty-initial-configuration
```
### Set Up Audio
Mic/Speaker on the top of the case - A1 is not working. A2 is working
HDMI/DisplayPort Audio - recommended for audio via TV speaker. Both audio via HDMI and DisplayPort works. 

Digital Output - No physical link/plug found

### Verify GPU Accelerated Desktop
Install glmark2 
```
sudo apt install glmark2
glmark2
# Check the render is Nvidia not LLVM
```

### Setup Multiple Monitors 
On the desktop GUI, start Settings->Displays, and then adjust the display settings and adjust the relative position of the displays.

### Share Desktop Remotely 

#### Install x11VNC on remote workstation

```
sudo apt install x11vnc
```

#### Create password on remote workstation
```
$ x11vnc -storepasswd
Enter VNC password:
Verify password:
Write password to /home/ampere/.vnc/passwd?  [y]/n y
Password written to: /home/ampere/.vnc/passwd
```

#### Start VNC on remote workstation

##### Create the new session
Start a new `ssh` session and then create x11vnc session. 
```
x11vnc  -usepw -display :1
# try different display port until the following message 
# 'Autoprobing selected TCP port 59xx'
``` 

##### Connect to remote desktop from local clients
Download Remote Ripple[^4], and install it, and then connect to the server:59xx with the password saved on the server.

## Applications
### Install Flatpak

[Flatpak](https://flatpak.org/) collected a lots of applications that supports both amd64 and Aarch64/Arm64. On Ubuntu, it can be installed with the follow commands.
```
sudo add-apt-repository ppa:flatpak/stable
sudo apt update
sudo apt install flatpak
```
#### Install Flatpak Plugin
```
sudo apt install gnome-software-plugin-flatpak
```
**Note**: Installing applications from GUI might be broken.

#### Add Flatpak Repository

```
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```
#### Date/Time Issue
If any of the commands above failed, it might be date/time issue. Use the following commands to update the system time and re-run the commands again. 
```
sudo apt install ntp
sudo systemctl restart ntp
```

### Install Dhewm3 - Open Source Version of DOOM3
#### Install the Application
```
flatpak install flathub org.dhewm3.Dhewm3
```
#### Download and Install Doom3 Demo Package
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

#### Run DOOM3
```
flatpak run org.dhewm3.Dhewm3
#Run doom3 in full screen
flatpak run org.dhewm3.Dhewm3 +set r_fullscreen 1
```

**Note**: With more than one monitors, the game windowed could be anywhere, while the fullscreen game  will be on the primary window. 

Please refer to Enable Nvidia GPU accelerated Ubuntu Desktop to set up primary window.

For more startup parameters, check this [document](https://modwiki.dhewm3.org/Startup_parameters).

## Applications Development
WIP
## References
[^4]: https://remoteripple.com/