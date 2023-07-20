![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# NVIDIA GPU Accelerated Linux Desktop on Ampere

## Summary

This repo contains scripts and documents to assist in the installation of GPU accelerated Linux desktops,  applications, and application development.

## Table of Contents
* [Introduction](#introduction)
* [Requirements](#requirements)
  * [Hardware](#hardware)
  * [Operating System](#operating-system)
* [Hardware Environment](#hardware-environment)
  * [Monitors Connected to Builtin VGA](#monitors-connected-to-builtin-vga)
  * [Monitors Connected to GPU Video](#monitors-connected-to-gpu-video-output)
  * [Install Nvidia GPU](#install-nvidia-gpu)
  * [GPU Power Connectors](#gpu-power-connectors)
  * [Set Up Audio](#set-up-audio)
* [Installation Guide](#installation-guide)
  * [Install Ubuntu Desktop](#install-ubuntu-desktop)
* [Applications](#applications)
  * [Install Flatpak](#install-flatpak)
  * [Install Dhewm3 - Open Source Version of DOOM3](#install-dhewm3---open-source-version-of-doom3)
  * [TODO]Paraview
  * [TODO]Salome
  * [TODO]GMSH
  * [TODO]Yolov8
* [Application Development](#applications-development)
  * [TODO]Electron
  * [TODO]VS Code
  * [TODO]Flutter
  * [TODO]Android Studio
  * [TODO]Jetson 
* [Application Libraries](#applications-libraries)
  * OpenCL(#opencl)
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
1.  Ubuntu 20.04 or 22.04 (server) for arm64
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

### Set Up Audio
Mic/Speaker on the top of the case - A1 does not not work, while those of A2 works.

HDMI/DisplayPort Audio - recommended for audio via TV speaker. Both audio via HDMI and DisplayPort works. 

Digital Output - No physical link/plug found

## Installation Guide

### Install Ubuntu Desktop

#### Install Ubuntu 20.04 or 22.04 Server with USB
1. Download Ubuntu 22.04 server 
1. Install ubuntu with HWE Server


#### Install GPU driver

##### Disable `aspm` from kernel

```
$ sudo nano /etc/default/grub
# Add pcie_aspm=off to kernel parameters
# GRUB_CMDLINE_LINUX_DEFAULT="pcie_aspm=off"
$ sudo update-grub
$ sudo reboot
```
##### Download and Install GPU Driver
Download Nvidia GPU driver from Nvidia's site[^2] and install GPU driver with the follow script. 
```
# Make sure the driver package name is updated in the script
$ ./install_gpu_driver.sh
```
Check the GPU driver is working with the following command.
```
nvidia-smi
```
#### Install Desktop Environment 
```
sudo apt install ubuntu-desktop
sudo reboot
```
**Note**: There are no output to the monitor attached to GPU before desktop. 

### Verify GPU Accelerated Desktop with glmark2
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
Download Remote Ripple[^3], and install it, and then connect to the server:59xx with the password saved on the server.

## Applications
### Install Flatpak

Flatpak[^4] collected a lots of applications that supports both amd64 and Aarch64/Arm64. On Ubuntu, it can be installed with the follow commands.
```
sudo ./scripts/install_flatpak.sh
```
**Note**: Installing applications from GUI might be broken.

Date/Time Issue
If any of the commands above failed, it might be date/time issue. Use the following commands to update the system time and re-run the commands again. 
```
sudo apt install ntp
sudo systemctl restart ntp
```

### Install Dhewm3 - Open Source Version of DOOM3

Install Dhewm3 and Demo Pack of DOOM3 with the following command[^5]. 
```
sudo ./scripts/install_dhewm3.sh
```

Run DOOM3
```
flatpak run org.dhewm3.Dhewm3
#Run doom3 in full screen
flatpak run org.dhewm3.Dhewm3 +set r_fullscreen 1
```
**Note**: With more than one monitors, the game windowed could be anywhere, while the full-screen game  will be on the primary window. 

For more startup parameters, check this document[^6].

### Enable Arm32 (Armhf) environment
Ampere Altra family processors support both Arm64 and Arm32, but to run Arm32 applications on Arm64 OS, an Arm32 environment need to be created. On Ubuntu 64 OS, the approach is `debootstrap` for `chroot`. 

#### Install debootstrap
```
sudo apt install schroot debootstrap
sudo mkdir /srv/chroot
sudo mkdir /srv/chroot/debian-armhf
sudo debootstrap --arch armhf --foreign buster /srv/chroot/debian-armhf http://debian.xtdv.net/debian
sudo chroot "/srv/chroot/debian-armhf" /debootstrap/debootstrap --second-stage
```

Then add a config file for `debian-armhf`:
```
sudo nano /etc/schroot/chroot.d/debian-armhf.conf
```
Copy paste this code, and change <username> into your computer username
```
[debian-armhf]
description=Debian Armhf chroot
aliases=debian-armhf
type=directory
directory=/srv/chroot/debian-armhf
profile=desktop
personality=linux
preserve-environment=true
root-users=<username>
users=<username>
```
#### Then edit the nssdatabases
```
sudo nano /etc/schroot/desktop/nssdatabases
```
copy paste this code
```
# System databases to copy into the chroot from the host system.
#
# <database name>
#passwd
shadow
#group
gshadow
services
protocols
#networks
#hosts
#user
```
#### Edit the stateoverride, and change the first contrab to root
```
sudo nano /srv/chroot/debian-armhf/var/lib/dpkg/statoverride
```
copy paste this code
```
root root 2755 /usr/bin/crontab
```
#### Now you should be able to schroot by typing
```
sudo schroot -c debian-armhf
```
#### Edit the bashrc
```
nano ~/.bashrc
```
add this code to the bottom of the line
```
export LANGUAGE="C"
export LC_ALL="C"
export DISPLAY=:0
```
### let's restart chroot environment by exit and login again, then add a username that is similar to your main system username

```
exit
id
sudo schroot -c debian-armhf
adduser <username>
su - <username>
```
then again add bashrc
``
nano ~/.bashrc
```
again add this code to the bottom of the line
```
export LANGUAGE="C"
export LC_ALL="C"
export DISPLAY=:0
```
#### Then restart chroot by double exit and login again, then install the following package
```
exit
sudo schroot -c debian-armhf
apt update && apt upgrade
```
More details on setting up Arm32 environment [^7].

### Install AnyDesk
Download RPi version `anydesk_6.2.1-1_armhf.deb`
```

echo deb http://archive.raspberrypi.org/debian/ bullseye main | sudo tee /etc/apt/sources.list.d/raspberrypi.list
deb http://archive.raspberrypi.org/debian/ bullseye main

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7FA3303E

wget -qO - http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | sudo apt-key add -


sudo dpkg --add-architecture armhf
sudo apt install libpolkit-gobject-1-0:armhf libraspberrypi0:armhf libraspberrypi-dev:armhf libraspberrypi-bin:armhf libgles-dev:armhf libegl-dev:armhf
sudo ln -s /usr/lib/arm-linux-gnueabihf/libGLESv2.so /usr/lib/libbrcmGLESv2.so
sudo ln -s /usr/lib/arm-linux-gnueabihf/libEGL.so /usr/lib/libbrcmEGL.so
```
Create and Enter Arm32 environment.
```
dpkg -i anydesk_6.2.1-1_armhf.deb
# Error messages on dependencies

# Install dependency

```
(debian-armhf)root@adlink:/home/ampere/Downloads# ldd /usr/bin/anydesk

  ...
  libpolkit-gobject-1.so.0 => not found
  ...
	libbcm_host.so => not found
	libvcos.so => not found
	libvchiq_arm.so => not found
	libbrcmGLESv2.so => not found
	libbrcmEGL.so => not found
  ...

  apt-get install -y libpolkit-gobject-1-dev
```
## Applications Development
WIP

## Application Libraries
### OpenCL
Although OpenCL on Arm is not well supported from Nvidia[^8] and AMD, but PoCL[^9] can be the workaround. 
Here is the steps to install pocl(-cuda) and check OpenCL info. 
```
# https://github.com/pocl/pocl
$ wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh
$ bash Mambaforge-$(uname)-$(uname -m).sh  # install mambaforge
# Agree to license, and Yes to all questions
$ cd ~/mambaforge/bin/
$ ./mamba install pocl-cuda
# $ ./mamba install pocl
$ sudo apt install clinfo
$ clinfo
```
Note: there might some errors reported on clinfo. 

## References
[^1]: https://www.adlinktech.com/Products/Computer_on_Modules/COM-HPC-Server-Carrier-and-Starter-Kit/Ampere_Altra_Developer_Platform
[^2]: https://www.nvidia.com/Download/driverResults.aspx/204838/en-us/
[^3]: https://remoteripple.com/
[^4]: https://flatpak.org/
[^5]: https://dhewm3.org/#how-to-install
[^6]: https://modwiki.dhewm3.org/Startup_parameters
[^7]: https://forum.armbian.com/topic/16584-install-box86-on-arm64/
[^8]: https://developer.nvidia.com/opencl
[^9]: https://github.com/pocl/pocl