#!/bin/bash

# docker images:  
#   melodic-ros-core, melodic-ros-base, melodic-ros-robot, melodic-perception, 
#   melodic-ros-core-stretch, melodic-ros-base-stretch, melodic-ros-robot-stretch, melodic-perception-stretch

#open -a XQuartz

ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
#xhost +

# X11:    apt-get install x11-apps
# opengl: apt-get install mesa-utils

img=waypoint_nav

docker run \
  --privileged \
  -it --rm \
  -p 5900:5900 \
  -p 5901:5901 \
  -v /dev:/dev \
  -v $(pwd)/src:/waypoint_nav/src \
  --name $img $img $@

#  --device=/dev/$(readlink /dev/tty.usbmodem1421) \
#  --device /dev/tty.usbmodem1421 \
#docker run -it --rm \
#  --name mow $img bash

#  -e DISPLAY=$ip:0 \
#  -v /tmp/X11-unix:/tmp/.X11-unix \
#  -v $(pwd):/autonomi \
#  -v /Users/jeffreylutz/code/autonomi.com/waypoint_nav:/husky/src \
#  -v /tmp/log/:/root/.ros/ \

