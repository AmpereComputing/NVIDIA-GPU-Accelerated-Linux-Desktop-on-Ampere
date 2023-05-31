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

## Applications Development
WIP












Run powershell as admin, then:

usbipd wsl list

usbipd wsl attach -a -b 1-2


----------------------------------------------------------------------------------------

In wsl:

install usbipd tools:
sudo apt install linux-tools-5.4.0-77-generic hwdata -y
sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/5.4.0-77-generic/usbip 20


Download the BSP and sample file system.


lsb_release -r
uname -r
lsusb
sudo docker run -it --privileged --net=host -v /dev/bus/usb:/dev/bus/usb -v /home/robbywang:/workspace nvcr.io/nvidia/jetson-linux-flash-x86:r35.3.1




----------------------------------------------------------------------------------------

In docker container:

    3  cd /workspace/
    5  tar -I lbzip2 -xf Jetson_Linux_R35.3.1_aarch64.tbz2
    6  cd Linux_for_Tegra/rootfs/
    7  tar -I lbzip2 -xpf ../../Tegra_Linux_Sample-Root-Filesystem_R35.3.1_aarch64.tbz2
    8  cd ..
    9  sudo ./apply_binaries.sh
   11  ./flash.sh --no-root-check jetson-agx-orin-devkit mmcblk0p1

   12  ls /dev/bus/usb
   20  sudo apt-get install usbutils -y
   21  lsusb

sudo reboot forced-recovery









#### Flashing Jetson device with WSL2 on X86

In some cases one might need to flash a Jetson device. Here's how to do so on WSL2 on X86 (flashing with Arm64 host PC is not supported by Nvidia)

Put your Jetson device in recovery mode, and connect with USB to host computer.
Install wsl and detach usb: (run steps 1,2,4,5,7)
https://forums.developer.nvidia.com/t/tutorial-using-sdkmanager-for-flashing-on-windows-via-wsl2-wslg/225759

Jetson flash container:
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/jetson-linux-flash-x86

Download Sample Root Filesystem and driver package(BSP)
https://developer.nvidia.com/embedded/jetson-linux

To find the <board> name when executing the ./flash.sh command:
For Orin AGX this is "jetson-agx-orin-devkit", you can also emulate other devices:
https://developer.ridgerun.com/wiki/index.php/NVIDIA_Jetson_Orin/JetPack_5.0.2/Flashing_Board

For other devices like Xavier, Nano:
https://docs.nvidia.com/jetson/archives/l4t-archived/l4t-3251/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/quick_start.html#wwpID0EAAMNHA


Other useful commands:
```
wsl -l to see a list of installed distro names
wsl --unregister <DistroName>
```


### Install and Running Yolov8 (on Jetson/Workstation)

#### Install DeepStream on Jetson
Link to Nvidia official document:
https://docs.nvidia.com/metropolis/deepstream/dev-guide/text/DS_Quickstart.html

Install libraries and kafka:
```
sudo apt install libssl1.1 libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstreamer-plugins-base1.0-dev libgstrtspserver-1.0-0 libjansson4 libyaml-cpp-dev
git clone https://github.com/edenhill/librdkafka.git
cd librdkafka
git reset --hard 7101c2310341ab3f4675fc565f64f0967e135a6a
./configure
make
sudo make install
sudo mkdir -p /opt/nvidia/deepstream/deepstream-6.2/lib
sudo cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream-6.2/lib
```

Install deepstream 6.2 using the Jetson tar package:
Current link to download the package:
https://developer.nvidia.com/downloads/deepstream-sdk-v620-jetson-tbz2
After download, change directory to the folder with the downloaded tbz2 package:
```
sudo tar -xvf deepstream_sdk_v6.2.0_jetson.tbz2 -C /
cd /opt/nvidia/deepstream/deepstream-6.2
sudo ./install.sh
sudo ldconfig
```

#### Verify deepstream installation: do this with display attached!
```
cd /opt/nvidia/deepstream/deepstream-6.2/samples/configs/deepstream-app
deepstream-app -c source30_1080p_dec_preprocess_infer-resnet_tiled_display_int8.txt 
```

#### To boost the clocks on Jetson:

```
sudo nvpmodel -m 0
#It may ask you to reboot. If not, reboot Jetson with "sudo reboot now"
sudo nvpmodel -m 0
sudo jetson_clocks
```


#### Install/upgrade pip3
```
sudo apt update
sudo apt install -y python3-pip
pip3 install --upgrade pip
#Might need to update path, if so, use script below:
export PATH="/home/jetson/.local/bin:$PATH"
echo $PATH
#To check if pip3 is correctly updated:
pip3 --version
```

#### Install ultralytics Yolo and requirements
```
cd ~
git clone https://github.com/ultralytics/ultralytics.git
cd ultralytics/
vi requirements.txt
```

Edit the file: Prepend # to the line "torch" and "torchvision", remove the # to line "onnx". We will be installing torch and torchvision manually in the next step.
```
pip3 install -r requirements.txt
```


#### Install pytorch. See reference here:
https://docs.nvidia.com/deeplearning/frameworks/install-pytorch-jetson-platform/index.html

#This following line might not be needed but it is reqd by previous pytorch(v1.8.0)
```sudo apt-get install -y libopenblas-base libopenmpi-dev```

Install the libraries:
```
sudo apt-get -y install autoconf bc build-essential g++-8 gcc-8 clang-8 lld-8 gettext-base gfortran-8 iputils-ping libbz2-dev libc++-dev libcgal-dev libffi-dev libfreetype6-dev libhdf5-dev libjpeg-dev liblzma-dev libncurses5-dev libncursesw5-dev libpng-dev libreadline-dev libssl-dev libsqlite3-dev libxml2-dev libxslt-dev locales moreutils openssl python-openssl rsync scons python3-pip libopenblas-dev;
```

Download the latest pytorch wheel from here:
https://forums.developer.nvidia.com/t/pytorch-for-jetson/72048

Latest version is 2.0.0. Run(Caution: sometimes Nvidia doesn't allow wget download, best way is to click on the link and download from browser):
```
wget https://developer.download.nvidia.cn/compute/redist/jp/v51/pytorch/torch-2.0.0a0+fe05266f.nv23.04-cp38-cp38-linux_aarch64.whl
```

Export the path to the downloaded file.(I put it in the ~ folder)
```
export TORCH_INSTALL=~/torch-2.0.0+nv23.05-cp38-cp38-linux_aarch64.whl 
```

Install pytorch on Jetson.
```
python3 -m pip install aiohttp numpy=='1.19.4' scipy=='1.5.3' export LD_LIBRARY_PATH="/usr/lib/llvm-8/lib:$LD_LIBRARY_PATH"; python3 -m pip install --upgrade protobuf; python3 -m pip install --no-cache $TORCH_INSTALL
```

There might be error in the previous step, but could be okay. To test pytorch installation:
(Reference: https://forums.developer.nvidia.com/t/pytorch-for-jetson/72048)

#### Test pytorch installation
```
python3 -i
>>> import torch
>>> print(torch.__version__)
>>> print('CUDA available: ' + str(torch.cuda.is_available()))
>>> print('cuDNN version: ' + str(torch.backends.cudnn.version()))
>>> a = torch.cuda.FloatTensor(2).zero_()
>>> print('Tensor a = ' + str(a))
>>> b = torch.randn(2).cuda()
>>> print('Tensor b = ' + str(b))
>>> c = a + b
>>> print('Tensor c = ' + str(c))
```
  

#### Install torchvision: 
(Reference: https://forums.developer.nvidia.com/t/pytorch-for-jetson/72048)

```
sudo apt-get install libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev
```

Please see the reference website for compatibility matrix, but for pytorch version 2.0.0, torchvision 0.15.1 is compatible.
```
git clone --branch v0.15.1 https://github.com/pytorch/vision torchvision
cd torchvision/
export BUILD_VERSION=0.15.1
python3 setup.py install --user
```

To test torchvision you must exit the installation directory:
```
cd ..
python3 -i
>>> import torchvision
>>> print(torchvision.__version__)
```


#### Pull deepstream-yolo for Yolov8 test run and configs, for reference:
https://github.com/marcoslucianops/DeepStream-Yolo/blob/master/docs/YOLOv8.md

```
cd ~
git clone https://github.com/marcoslucianops/DeepStream-Yolo
cp DeepStream-Yolo/utils/export_yoloV8.py ultralytics/
cd ~/ultralytics
wget https://github.com/ultralytics/assets/releases/download/v0.0.0/yolov8s.pt
```

----------------------------------
Failed attempt to install onnxsim and onnxruntime:
```
sudo apt-get install cmake
pip3 install onnxsim onnxruntime
```
----------------------------------
onnxsim and onnxruntime installation have problems, so we don't need the --simplify flag.
```python3 export_yoloV8.py -w yolov8s.pt```

To change the inference size (defaut: 640)
-s SIZE
--size SIZE
-s HEIGHT WIDTH
--size HEIGHT WIDTH

```
cp yolov8s.onnx ../DeepStream-Yolo/
cd ../DeepStream-Yolo/
CUDA_VER=11.4 make -C nvdsinfer_custom_impl_Yolo
```

If want to change the detected classes(default is 80):
```
vi config_infer_primary_yoloV8.txt 
```

Configurate deepstream run:
Make sure the config-file is set:
```
[primary-gie]
...
config-file=config_infer_primary_yoloV8.txt

#Also if want to loop the video infinitely:
[tests]
file-loop=1
```

You can also configure the input video and resolution of the run. For more information:
https://docs.nvidia.com/metropolis/deepstream/dev-guide/text/DS_ref_app_deepstream.html#configuration-groups
https://github.com/marcoslucianops/DeepStream-Yolo/blob/master/docs/customModels.md
https://maouriyan.medium.com/the-friendly-guide-to-build-deepstream-application-3e78cb36d9f2

#### To run Yolov8:
```
vi deepstream_app_config.txt 
deepstream-app -c deepstream_app_config.txt
```



## References
[^1]: https://www.adlinktech.com/Products/Computer_on_Modules/COM-HPC-Server-Carrier-and-Starter-Kit/Ampere_Altra_Developer_Platform
[^2]: https://www.nvidia.com/Download/driverResults.aspx/204838/en-us/
[^3]: https://remoteripple.com/
[^4]: https://flatpak.org/
[^5]: https://dhewm3.org/#how-to-install
[^6]: https://modwiki.dhewm3.org/Startup_parameters
