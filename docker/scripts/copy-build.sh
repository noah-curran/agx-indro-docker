#!/bin/bash

# Location where repos were cloned during build
BUILD_LOCATION="/opt/workspaces/isaac_ros-dev"

# Location to copy into
COPY_LOCATION="/workspaces"

echo "Copying build into mounted workspace"

cp -r ${BUILD_LOCATION} ${COPY_LOCATION}
rm -rf ${BUILD_LOCATION}
