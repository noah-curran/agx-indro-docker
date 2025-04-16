# !/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Download kernel sources which match this version. For Jetpack 6.0 this is r363
cd /tmp/
wget https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.0/sources/public_sources.tbz2

# Extract sources
tar -xvf public_sources.tbz2
cd Linux_for_Tegra/source
tar -xvf kernel_src.tbz2

# Build menuconfig to edit source config
cd kernel/kernel-jammy-src
# cp ${ISAAC_ROS_WS}/agx-indro-docker/.config .config
zcat /proc/config.gz > .config
make oldconfig
sudo apt-get update && sudo apt-get install build-essential libncurses5-dev bc libssl-dev

# In this menu do:
# Networking support →  CAN bus subsystem support →  CAN Device Drivers →  CAN USB interfaces →  Geschwister Schneider UG (gs_usb)
# Press M, then save and exit
make menuconfig

# EDITED FROM ORIGINAL VERSION TO SAVE TIME
# Build modules and add gs_usb to kernel drivers
make modules_prepare
make M=drivers/net/can/usb -j4
find . -name "gs_usb.ko" # Probably at drivers/net/can/usb/gs_usb.ko
sudo mkdir -p /lib/modules/$(uname -r)/kernel/drivers/net/can/usb/
sudo cp drivers/net/can/usb/gs_usb.ko /lib/modules/$(uname -r)/kernel/drivers/net/can/usb
sudo cp divers/net/can/usb/gs_usb.ko ${SCRIPT_DIR}

sudo depmod -a

# Load gs_usb
sudo modprobe gs_usb
# Verify it is loaded
lsmod | grep gs_usb
# Make it load at boot
echo "gs_usb" | sudo tee -a /etc/modules

