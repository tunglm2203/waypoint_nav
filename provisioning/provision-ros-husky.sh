#!/bin/bash

set -e

##  Source ros setup.bash
source /opt/ros/kinetic/setup.bash

#################
# Install husky navigation ros stuff
# URL: http://www.clearpathrobotics.com/assets/guides/husky/HuskyGPSWaypointNav.html

#### Install dependencies
apt-get update
#apt-get upgrade -y

#### Install dependencies
apt-get install -y ros-kinetic-gazebo-* ros-kinetic-husky-* ros-kinetic-robot-localization ros-kinetic-move-base

#### Clone roboteq_diff_driver
cd /
mkdir -p /husky/src
cd /husky

cd /husky/src && git clone https://github.com/nickcharron/waypoint_nav && cd /husky

echo "IMPORTANT: Soure the /husky/devel/setup.bash script!"
cd /husky && catkin_make

# IMPORTANT:  Source the devel/setup.bash script!
echo "IMPORTANT: Soure the devel/setup.bash script!"
source devel/setup.bash

echo "#!/bin/bash" > /husky/waypoint_sim.sh
echo "cd /husky" >> /husky/waypoint_sim.sh
echo "source devel/setup.bash" >> /husky/waypoint_sim.sh
echo "roslaunch outdoor_waypoint_nav outdoor_waypoint_nav_sim.launch" >> /husky/waypoint_sim.sh
chmod a+x /husky/waypoint_sim.sh

echo ROS Husky modules setup is a SUCCESS!
