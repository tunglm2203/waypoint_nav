#!/bin/bash 

xhost +local:root

img=autonomi-mower

docker run \
--privileged \
-it --rm \
-p 5900:5900 \
-p 5901:5901 \
-v /dev:/dev \
--env="DISPLAY"  \
--env="QT_X11_NO_MITSHM=1"  \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--volume="/etc/group:/etc/group:ro" \
--volume="/etc/passwd:/etc/passwd:ro" \
--volume="/etc/shadow:/etc/shadow:ro" \
--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
--volume="$HOME/host_docker:/home/user/host_docker" \
-e LOCAL_USER_ID=`id -u $USER` \
-e LOCAL_GROUP_ID=`id -g $USER` \
-e LOCAL_GROUP_NAME=`id -gn $USER` \
--entrypoint "/bin/bash" \
--name $img $img$@



xhost -local:root
