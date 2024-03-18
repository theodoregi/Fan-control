#!/bin/bash

TEMP_PATH="/sys/devices/virtual/thermal/thermal_zone0/temp"
FAN_PATH="/sys/class/thermal/cooling_device0/cur_state"

get_fan_speed() {
    speed=$(sudo cat $FAN_PATH)
    echo $speed
}

get_temp() {
    temp=$(sudo cat $TEMP_PATH)
    echo $((temp / 1000))
}

main() {
    while true; do
        temp=$(get_temp)
	speed=$(get_fan_speed)
        echo "temp  : "$temp"°"
        echo "speed : "$speed
        sleep 1
    done
}

trap 'exit 0' SIGINT SIGTERM

main
