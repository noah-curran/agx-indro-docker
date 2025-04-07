# Installation
First, make sure you have [Isaac ROS](https://nvidia-isaac-ros.github.io/getting_started/dev_env_setup.html) setup with your workspace. We build the Dockerfiles here based on Isaac ROS's layered docker build process.

```bash
# Whatever your ROS2 workspace is. When using Isaac ROS it might be ${ISAAC_ROS_WS}.
cd ${WORKSPACE}
git clone https://github.com/noah-curran/agx-indro-docker.git
cp agx-indro-docker/.isaac_ros_common-config src/isaac_ros_config/scripts/
```
