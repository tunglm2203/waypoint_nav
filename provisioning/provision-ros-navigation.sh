#!/bin/bash

set -e

su - ros -c "cd /mower && source /opt/ros/${ROS_DISTRO}/setup.bash && catkin_make && catkin_make install"