# Installation
First, make sure you have [Isaac ROS](https://nvidia-isaac-ros.github.io/getting_started/dev_env_setup.html) setup with your workspace. We build the Dockerfiles here based on Isaac ROS's layered docker build process.

You also want to make sure that the `gs\_usb` header is available. You can use the provided script `setup-jetson-can.sh`. It will give you a menu at some point and you need to follow `Networking support → CAN bus subsystem support → CAN Device Drivers → CAN USB interfaces → Geschwister Schneider UG (gs_usb)`. Then, press M, save, and exit.

Finally you can copy and run the docker.
```bash
# Whatever your ROS2 workspace is. When using Isaac ROS it will probably be ${ISAAC_ROS_WS}.
cd ${ISAAC_ROS_WS}
git clone https://github.com/noah-curran/agx-indro-docker.git
cp agx-indro-docker/.isaac_ros_common-config src/isaac_ros_config/scripts/
cd src/isaac_ros_common && ./scripts/run_dev.sh -d ${ISAAC_ROS_WS}
```
