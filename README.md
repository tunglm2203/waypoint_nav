# GPS-waypoint-based-Autonomous-Navigation-in-ROS
GPS points will be predefined for the robot to navigate to the destination while avoiding obstacles.


# Description

This repo package was tested on Gazebo simulator (version 9.0) with a Omo R1/R1 mini with IMU, GPS, and lidar. The PC is running Ubuntu 18.04, ROS Melodic, Gazebo 9.0.

This package uses a combination of the following packages:

	- ekf_localization to fuse odometry data with IMU and GPS data

	- navsat_transform to convert GPS data to odometry and to convert latitude and longitude points to the robot's odometry coordinate system

	- GMapping to create a map and detect obstacles
	
	- move_base to navigate to the goals while avoiding obstacles (goals are set using recorded or inputted waypoints)

The outdoor_waypoint_nav package within waypoint_nav includes the following custom nodes:
	
	- gps_waypoint to read the waypoint file, convert waypoints to points in the map frame and then send the goals to move_base
	
	- gps_waypoint_continuous1 and gps_waypoint_continuous2 for continuous navigation between waypoints using two seperate controllers
	
	- collect_gps_waypoint to allow the user to drive the robot around and collect their own waypoints
	
	- calibrate_heading to set the heading of the robot at startup and fix issues with poor magnetometer data
	
	- plot_gps_waypoints to save raw data from the GPS for plotting purposes
	
	- gps_waypoint_mapping to combine waypoint navigation with Mandala Robotics' 3D mapping software for autonomous 3D mapping


# Quick start

----------------
### Setup required packages:

Clone the modified omo_r1 (branch dev_r1d2_gps_navigation) and waypoint_nav packages:

```
cd ~/catkin_ws/src

git clone https://github.com/tunglm2203/mobilio.git
cd mobilio
git checkout dev_r1d2_gps_navigation    # Checkout branch "dev_r1d2_gps_navigation"
cd ..

git clone https://github.com/tunglm2203/waypoint_nav.git
cd waypoint_nav
cd checkout dev_r1d2                    # Checkout branch "dev_r1d2"
cd ..

git clone https://github.com/cra-ros-pkg/robot_localization.git
cd robot_localization
git checkout melodic-devel              # Checkout branch "melodic-devel"
cd ..

git clone https://github.com/tunglm2203/mapviz.git

git clone https://github.com/tunglm2203/rviz_satellite.git

cd ~/catkin_ws
catkin_make 
```

Setup mapviz following https://github.com/danielsnider/MapViz-Tile-Map-Google-Maps-Satellite.git (docker is required)

Remember to run the docker first before following commands. For quickly, execute the following command so the google map can be displayed on mapviz:
```
sudo docker run -p 8080:8080 -d -t -v ~/mapproxy:/mapproxy danielsnider/mapproxy
```

### Start:

- To run in simulator (tested on Ubuntu 18.04, ROS melodic):
In first terminal, run:
```
roscore
```

- In second terminal, run:
```
roslaunch outdoor_waypoint_nav outdoor_waypoint_nav_sim.launch
```

- Wait a few minutes for launching gazebo (don't run it right away, the move_base process can have problem), and open third terminal, run:
```
roslaunch outdoor_waypoint_nav send_goals_sim.launch
```

# Required packages for simulator (TBU)
```
sudo apt-get install -y ros-$ROS_DISTRO-cartographer-ros ros-$ROS_DISTRO-marti-common-msgs \
    ros-$ROS_DISTRO-hector-gazebo-plugins ros-$ROS_DISTRO-swri-* ros-$ROS_DISTRO-move-base-* \
    ros-$ROS_DISTRO-usb-cam ros-$ROS_DISTRO-mapviz ros-$ROS_DISTRO-mapviz-plugins \
   ros-$ROS_DISTRO-tile-map ros-$ROS_DISTRO-multires-image
```


# Acknowledgement

- https://github.com/ArghyaChatterjee/gps-waypoint-based-autonomous-navigation-in-ros
- https://github.com/nickcharron
- https://github.com/nobleo/rviz_satellite
- https://github.com/danielsnider/MapViz-Tile-Map-Google-Maps-Satellite
- https://github.com/swri-robotics/mapviz
