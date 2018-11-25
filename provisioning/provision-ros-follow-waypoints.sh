#!/bin/bash

set -e

source /opt/ros/kinetic/setup.bash

cd /
mkdir follow-waypoints
cd /follow-waypoints
mkdir src
cd src
git clone https://github.com/danielsnider/follow_waypoints
cd follow_waypoints
cp /misc/* .
cd ../..
catkin_make

# copy script to launch
cp /provisioning/launch-follow-waypoints.sh /follow-waypoints/.


