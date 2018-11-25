#!/bin/bash

set -e

#################
# Install RobotEq diff steering ROS serial module
# URL: https://github.com/ecostech/roboteq_diff_driver

#################
# Install Swift Navigation's Piksi Multi ROS device
# URL: https://support.swiftnav.com/customer/portal/articles/2924342

#### Install dependencies
echo CLEANING!
apt-get clean
apt-get update
apt-get upgrade -y
apt-get install -y sudo less vim-tiny python-pip x11-apps
apt-get install -y ros-${ROS_DISTRO}-teleop-twist-keyboard ros-${ROS_DISTRO}-navigation ros-${ROS_DISTRO}-serial

#### Clone roboteq_diff_driver
cd /
mkdir -p /mower/src /mower/launch /mower/scripts
chown -R ros:ros /mower
su - ros -c "cd /mower/src && git clone https://github.com/ecostech/roboteq_diff_driver"
su - ros -c "cd /mower/src && git clone https://github.com/ethz-asl/ethz_piksi_ros"

#### Build everyone within /mower/src by running catkin_make within /mower dir
su - ros -c "cd /mower && source /opt/ros/${ROS_DISTRO}/setup.bash && catkin_make --pkg piksi_rtk_msgs && catkin_make install"
su - ros -c "echo source /mower/install/setup.bash >> ~/.bashrc"

echo source /mower/install/setup.bash >> ~/.bashrc


#### Install simple nav example:
#### http://www.moorerobots.com/blog/post/1
cd /
git clone -b base https://github.com/richardw05/mybot_ws.git
cd /mybot_ws
source /opt/ros/${ROS_DISTRO}/setup.bash && catkin_make


echo ROS Mower modules setup is a SUCCESS!
