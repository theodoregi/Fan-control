#!/bin/bash

FAN_PATH="/sys/class/thermal/cooling_device0/cur_state"

set_fan_speed() {
    speed=$1
    sudo echo $speed > $FAN_PATH
}

pid_fc=$(ps aux | grep fan_control | grep -v grep | awk '{print $2}' | head -n 1)
ps aux | grep fan_control | grep -v grep | head -n 1
if [ -z "$pid_fc" ]; then
    echo "No pid found"
else
    kill -9 $pid_fc
fi
set_fan_speed 0