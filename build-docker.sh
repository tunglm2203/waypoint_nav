#!/bin/bash

img=waypoint_nav
#docker build --no-cache -t "$img" .

docker build -t "$img" .
