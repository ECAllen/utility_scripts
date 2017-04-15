#!/bin/bash

# Settings
CAM_WIDTH=320
CAM_HEIGHT=240

DEVICE=/dev/video0

nohup mplayer tv:// -tv driver=v4l2:width=$CAM_WIDTH:height=$CAM_HEIGHT:device=$DEVICE &

sleep 5s

i3-msg '[title="MPlayer"] floating enable'
i3-msg '[title="MPlayer"] sticky enable'
