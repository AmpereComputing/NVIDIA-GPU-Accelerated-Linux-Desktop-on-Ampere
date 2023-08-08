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
  * [Install Yolov8 in container on Workstation](#install-and-running-yolov8-on-workstation-container)
  * [TODO]Paraview
  * [TODO]Salome
  * [TODO]GMSH
* [Application Development](#applications-development)
  * [Jetson](https://github.com/AmpereComputing/Jetson-on-Ampere)
  * [TODO]Electron
  * [TODO]VS Code
  * [TODO]Flutter
  * [TODO]Android Studio
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



### Install and Running Yolov8 on Workstation container
Prerequisite: Nvidia GPU and GPU driver installed on Workstation.
Nvidia container toolkit installed.
#### TODO: Installation scripts

Things to note: All relevant libraries/tools like CUDA, cuDNN, TensorRT will be enabled on Workstation for YOLO run, except DeepStream. DeepStream is only available in Jetson and X86 systems, so currently cannot be incorporated in workstation. YOLO is fully functional regardless of DeepStream installation.

We will use the pytorch image from NGC. This image has CUDA, cuDNN and TensorRT environment prebuilt.
```
sudo docker run --net=host -e DISPLAY=$DISPLAY --gpus all -it --rm --shm-size=1024M nvcr.io/nvidia/pytorch:23.06-py3
```

#### Install YOLO:
Note: pip is prebuilt in the container image. So you can just run this in the container to install YOLO:
```
pip install ultralytics
```

#### Test YOLO installation from command line:
```
yolo predict model=yolov8n.pt source='https://ultralytics.com/images/bus.jpg'
ls runs/detect/predict/bus.jpg
```

#### Test YOLO installation by running a Python script:
```
vi run.py
```

Paste the following content into the python file:
```
from ultralytics import YOLO
# Load a model
model = YOLO("yolov8n.yaml")  # build a new model from scratch
model = YOLO("yolov8n.pt")  # load a pretrained model (recommended for training)
# Use the model
model.train(data="coco128.yaml", epochs=3)  # train the model
metrics = model.val()  # evaluate model performance on the validation set
results = model("https://ultralytics.com/images/bus.jpg")  # predict on an image
path = model.export(format="onnx")  # export the model to ONNX format
```

Execute the file:
```
python3 run.py
```

TODO:failed when executing "pip install onnxruntime-gpu"


## Applications Development
TODO

## References
[^1]: https://www.adlinktech.com/Products/Computer_on_Modules/COM-HPC-Server-Carrier-and-Starter-Kit/Ampere_Altra_Developer_Platform
[^2]: https://www.nvidia.com/Download/driverResults.aspx/204838/en-us/
[^3]: https://remoteripple.com/
[^4]: https://flatpak.org/
[^5]: https://dhewm3.org/#how-to-install
[^6]: https://modwiki.dhewm3.org/Startup_parameters