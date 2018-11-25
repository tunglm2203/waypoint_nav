#!/bin/bash

set -e

source /opt/ros/kinetic/setup.bash

cd /
mkdir -p urc/src
cd /urc/src
git clone https://github.com/jeffreylutz/URC
cd ..
catkin_make


