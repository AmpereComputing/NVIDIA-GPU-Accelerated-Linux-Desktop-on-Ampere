
# Hardware Environment
AADP A1 has bug on grub and **A2** version is recommended.

## Monitors connected to builtin VGA
One monitor can connect to builtin VGA output is required on setup process.

## Monitors connected to GPU video
Although it can run with only one monitor attached to GPU video output, but the booting processes information will not be able to show on the monitor attached to GPU. 

## Recommended Nvidia GPUs
Nvidia RTX series GPU with one or more displayport and/or HDMI video output are recommended.


## Install Nvidia GPU
Install GPU at one of the two PCIex16 slots and connect power cables if needed.

## GPU power connectors
The box comes with a spare GPU power cable hidden at the back of motherboard. 

# Software Environment
- Ubuntu 20.04 or 22.04 server
- Nvidia GPU driver
- Desktop environment

# Installation Guide
## Install Ubuntu 20.04 or 22.04 with USB
1. Download Ubuntu 22.04 server. 
1. Install ubuntu with HWE

## Install GPU driver
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
## Install Desktop environment 
```
$ sudo apt install ubuntu-desktop
```
Enable GPU accelerated desktop
```
$ sudo nvidia-xconfig -a --cool-bits=31 --allow-empty-initial-configuration
```
# Set up Audio
Mic/Speaker on the top of the case - A1 is not working. A2 is working
HDMI/DisplayPort Audio - recommended for audio via TV speaker. Both audio via HDMI and DisplayPort works. 

Digital Output - No physical link/plug found

# Verify GPU accelerated desktop
Install glmark2 
```
sudo apt install glmark2
glmark2
# Check the render is Nvidia not LLVM
```

# Multiple monitors 
On the desktop GUI, start Settings->Displays, and then adjust the display settings and adjust the relative position of the displays.
