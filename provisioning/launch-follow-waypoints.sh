#!/bin/bash

set -e

cd /follow-waypoints
source /opt/ros/kinetic/setup.bash

catkin_make

source devel/setup.bash

roslaunch follow_waypoints follow_waypoints.launch

echo "To run path:  rostopic pub /path_ready std_msgs/Empty -1"
echo "To clear:     rostopic pub /path_reset std_msgs/Empty -1"
