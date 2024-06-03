#!/bin/bash

IMAGE=${IMAGE:-"jl_base:stable-20.4"}
DUSER=`id -u`
JUPYTER_PORT=${JUPYTER_PORT:-1234}

docker run -v $PWD:/home/$USER -e USER=$USER -e IF_main_port=${JUPYTER_PORT} -e DISPLAY=${DISPLAY}  -v /etc/passwd:/etc/passwd -it -v /tmp/.X11-unix:/tmp/.X11-unix -v ${HOME}/.Xauthority:/home/jovyan/.Xauthority:rw --net=host --user ${DUSER} ${IMAGE}

