FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

# built-in packages
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y usbutils vim

#RUN apt-get install -y --no-install-recommends software-properties-common curl \
#    && sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list" \
#    && curl -SL http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key | apt-key add - \
#        openssh-server arc-theme \

RUN apt-get install -y --no-install-recommends software-properties-common curl \
    && add-apt-repository ppa:fcwu-tw/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor \
        pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine \
        pinta \
        dbus-x11 x11-utils \
        terminator \
        gpsd-clients gpsd \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Hello World!"

# =================================
# install ros (source: https://github.com/osrf/docker_images/blob/5399f380af0a7735405a4b6a07c6c40b867563bd/ros/kinetic/ubuntu/xenial/ros-core/Dockerfile)
# install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# 1.3 setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# Install ROS repo setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update \
    && apt-get install -y ros-kinetic-desktop-full ros-kinetic-rosmon \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
# COPY ./ros_entrypoint.sh /

# =================================

# user tools
RUN apt-get update && apt-get install -y \
    terminator \
    gedit \
    okular \
    && rm -rf /var/lib/apt/lists/*

################################################################
# install ROS Kinetic husky and gazebo
################################################################

################################################################
# tini for subreap
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini
################################################################

################################################################
# Add misc pip packages
ADD image /
RUN easy_install pip
#RUN pip install --upgrade pip
RUN pip install wheel
RUN pip install setuptools
RUN pip install -r /usr/lib/web/requirements.txt
################################################################

RUN cp /usr/share/applications/terminator.desktop /root/Desktop
RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc

################################################################
# Create ros user and group
RUN /usr/sbin/groupadd ros
RUN /usr/sbin/useradd -m -g ros ros -s /bin/bash
################################################################

################################################################
# Provision all ROS components for mower equipment
# Make sample launch files available for RobotEq motor controller
# Tele-op:  rosrun teleop_twist_keyboard teleop_twist_keyboard.py
RUN mkdir /provisioning
COPY provisioning/* /provisioning/
RUN /provisioning/provision-ros-mower.sh
COPY launch/*.launch /mower/launch/
COPY scripts/*.sh /mower/scripts/
################################################################

################################################################
# Install RTIMULib
RUN git clone https://github.com/jeffreylutz/RTIMULib2 && mkdir RTIMULib2/Linux/build && cd RTIMULib2/Linux/build && cmake .. && make install && echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> /etc/bash.bashrc
################################################################

################################################################
# Install TinkerForge IMU Brick V 2.0
# https://www.tinkerforge.com/en/doc/Software/Brickd_Install_Linux.html#brickd-install-linux

RUN export RUNLEVEL=1
RUN echo "export RUNLEVEL=1" >> /root/.bashrc
RUN echo exit 0 > /usr/sbin/policy-rc.d
RUN apt-get install -y wget
RUN wget http://download.tinkerforge.com/tools/brickd/linux/brickd_linux_latest_amd64.deb
RUN dpkg -i brickd_linux_latest_amd64.deb
# Install brick viewer gui
RUN apt-get install -y python python-qt4 python-qt4-gl python-opengl python-serial
RUN wget http://download.tinkerforge.com/tools/brickv/linux/brickv_linux_latest.deb && dpkg -i brickv_linux_latest.deb
################################################################

################################################################
# Provision waypoint_nav for husky
RUN apt-get install -y ros-kinetic-gazebo-* ros-kinetic-husky-* ros-kinetic-robot-localization ros-kinetic-move-base
RUN mkdir -p /waypoint_nav/src
VOLUME ["/waypoint_nav/src"]
################################################################

################################################################
# Install ROS teb local planner tutorial
RUN apt-get install -y ros-kinetic-teb-local-planner
################################################################

EXPOSE 80 6080 5900 5901
WORKDIR /root
RUN /etc/init.d/gpsd restart 2>&1 > /var/log/gpsd-restart.log
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
