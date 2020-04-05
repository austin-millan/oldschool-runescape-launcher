#!/bin/bash

docker run -ti \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       aamillan/oldschool-runescape-launcher \
       oldschool
