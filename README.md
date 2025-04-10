# Installation
First, make sure you have Isaac ROS setup with your workspace. We build the Dockerfiles here based on Isaac ROS's layered docker build process. Follow these guides in this order:
1. [Setup docker](https://jetsonhacks.com/2025/02/24/docker-setup-on-jetpack-6-jetson-orin/).
2. [Prepare your hardware](https://nvidia-isaac-ros.github.io/getting_started/hardware_setup/compute/index.html#jetson-platforms).
3. [Prepare your development environment](https://nvidia-isaac-ros.github.io/getting_started/dev_env_setup.html).
4. [Download Isaac ROS to workspace](https://nvidia-isaac-ros.github.io/getting_started/hardware_setup/sensors/realsense_setup.html). NOTE: Only follow this guide up to when `.isaac_ros_common-config` is mentioned, and then follow the guide below.

Clone this to our workspace.
```bash
# Whatever your ROS2 workspace is. When using Isaac ROS it will probably be ${ISAAC_ROS_WS}.
cd ${ISAAC_ROS_WS}
git clone https://github.com/noah-curran/agx-indro-docker.git
```

**_ONLY DO THIS IF YOU ARE USING A VERSION OF JETPACK THAT IS NOT 6.0._** You also want to make sure that the correct `gs_usb` header is available. You can use the provided script `setup-jetson-can.sh`. It will give you a menu at some point and you need to follow `Networking support → CAN bus subsystem support → CAN Device Drivers → CAN USB interfaces → Geschwister Schneider UG (gs_usb)`. Then, press M, save, and exit. There is a version of `gs_usb.ko` in `docker/` that works for the Isaac ROS image we used, but if the version of the Jetson header files changes then you will need to change the version in `setup-jetson-can.sh` and follow the process to copy a new version of `gs_usb.ko` to `docker/`.

Next, copy `gs_usb.ko` locally.
```bash
# If you have a different version from 5.15.136-tegra then you will need to follow instructions above for rebuilding gs_usb.ko.
# If you do this, consider creating a different branch and committing it to GitHub so we can keep different versions tagged.
sudo mkdir -r /lib/modules/5.15.136-tegra/kernel/drivers/net/can/usb
sudo cp ${ISAAC_ROS_WS}/agx-indro-docker/docker/gs_usb.ko /lib/modules/5.15.136-tegra/kernel/drivers/net/can/usb
sudo depmod -a
sudo modprobe gs_usb
```

Finally you can copy the config and run the docker.
```bash
cp agx-indro-docker/.isaac_ros_common-config src/isaac_ros_common/scripts/
cd src/isaac_ros_common && ./scripts/run_dev.sh -d ${ISAAC_ROS_WS}
```

If more custom layers are added and the Docker max layer depth is reached (usually after 127 layers you get this error: `Error response from daemon: max depth exceeded`) then you can increase the default limit for this. Please try anything possible to reduce the number of layers (i.e., by combining `RUN` commands or reducing `COPY` or `ADD` commands), so use this as a last resort effort.

1. `Edit /etc/docker/daemon.json`:
```json
{
  "max-container-image-layers": # number you want here
}
```
2. Restart Docker: `sudo systemctl restart docker`
