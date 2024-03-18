#!/bin/bash

TEMP_PATH="/sys/devices/virtual/thermal/thermal_zone0/temp"
FAN_PATH="/sys/class/thermal/cooling_device0/cur_state"

send_notification() {
    message=$1
    notify-send "Fan Control" "$message"
}

set_fan_speed() {
    speed=$1
    sudo echo $speed > $FAN_PATH
}

get_temp() {
    temp=$(sudo cat $TEMP_PATH)
    echo $((temp / 1000))
}

main() {
    previous_speed=0
    while true; do
        temp=$(get_temp)
        #echo $temp

        if [ $temp -gt 60 ]; then
            speed=4  # FULL
        elif [ $temp -gt 55 ]; then
            speed=3  # HIGH
        elif [ $temp -gt 50 ]; then
            speed=2  # MEDIUM
        else
            speed=1  # LOW
        fi
	if [ "$previous_speed" != "$speed" ]; then
            case $speed in
        	0) message="Fan Stopped" ;;
		1) message="Fan on Low Speed" ;;
		2) message="Fan on Medium Speed" ;;
		3) message="Fan on High Speed" ;;
		4) message="Fan on Full Speed" ;;
		*) message="Fan Speed Changed" ;;
            esac
	    send_notification "$message"
            set_fan_speed $speed
	    previous_speed=$speed
	fi
        sleep 2
    done
}

trap 'set_fan_speed 0; send_notification "Fan Stopped"; exit 0' SIGINT SIGTERM

main
