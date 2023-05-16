# Install Flatpak

[Flatpak](https://flatpak.org/) collected a lots of applications that supports both amd64 and Aarch64/Arm64. On Ubuntu, it can be installed with the follow commands.
```
sudo add-apt-repository ppa:flatpak/stable
sudo apt update
sudo apt install flatpak
```
## Install Flatpak plugin
```
sudo apt install gnome-software-plugin-flatpak
```
**Note**: Installing applications from GUI might be broken.

## Add Flatpak repository

```
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```
## Date/Time issue
If any of the commands above failed, it might be date/time issue. Use the following commands to update the system time and re-run the commands again. 
```
sudo apt install ntp
sudo systemctl restart ntp
```

# Install Dhewm3 - open source version of DOOM3  
## Install the application
```
flatpak install flathub org.dhewm3.Dhewm3
```
## Download and install Doom3 demo package
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

## Run DOOM3
```
flatpak run org.dhewm3.Dhewm3
#Run doom3 in full screen
flatpak run org.dhewm3.Dhewm3 +set r_fullscreen 1
```

**Note**: With more than one monitors, the game windowed could be anywhere, while the fullscreen game  will be on the primary window. 

Please refer to Enable Nvidia GPU accelerated Ubuntu Desktop to set up primary window.

For more startup parameters, check this [document](https://modwiki.dhewm3.org/Startup_parameters).
