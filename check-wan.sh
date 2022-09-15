#!/bin/sh /etc/rc.common

IP='8.8.8.8'
while true
do

        wan_status=$(swconfig dev switch0 port 5 get link | sed -r 's/.*link:([[:alnum:]]*).*/\1/')

        #Check if interface is down, Turn off LEDs
        if [ "$wan_status" == "down" ]
        then
                echo "WAN PORT  DOWN!"
                ##echo 0 > /sys/class/leds/pca963x:shelby:white:wan/brightness
                echo 0 > /sys/class/leds/blue:internet/brightness
                #echo 0 > /sys/class/leds/pca963x:shelby:amber:wan/brightness
                echo 0 > /sys/class/leds/red:internet/brightness


        #Check if interface is Up
        elif [ "$wan_status" == "up" ]
        then

                fping -c1 -t300 $IP 2>/dev/null 1>/dev/null
                SUCCESS=$?

                if [ $SUCCESS -eq 0 ]
                then
                        echo "$IP replied"
                        #echo 255 > /sys/class/leds/pca963x:shelby:white:wan/bri                                                                                                                                                             ghtness
                        echo 255 > /sys/class/leds/red:internet/brightness
                        #echo 0 > /sys/class/leds/pca963x:shelby:amber:wan/brigh                                                                                                                                                             tness
                        echo 255 > /sys/class/leds/blue:internet/brightness
                        #echo netdev > /sys/class/leds/pca963x:shelby:white:wan/                                                                                                                                                             trigger
                        #echo eth0 > /sys/class/leds/pca963x:shelby:white:wan/de                                                                                                                                                             vice_name
                        #echo 'link tx rx' > /sys/class/leds/pca963x:shelby:whit                                                                                                                                                             e:wan/mode
                        echo netdev > /sys/class/leds/red:internet/trigger
                        echo eth0.2 > /sys/class/leds/red:internet/device_name
                        echo 1 > /sys/class/leds/red:internet/rx
                        echo 1 > /sys/class/leds/red:internet/tx



                else
                        echo "$IP has not replied"
                        #echo 255 > /sys/class/leds/pca963x:shelby:amber:wan/bri                                                                                                                                                             ghtness
                        echo 255 > /sys/class/leds/red:internet/brightness
                        #echo 0 > /sys/class/leds/pca963x:shelby:white:wan/brigh                                                                                                                                                             tness
                        echo 0 > /sys/class/leds/blue:internet/brightness
                        #echo none > /sys/class/leds/pca963x:shelby:white:wan/tr                                                                                                                                                             igger
                        echo none > /sys/class/leds/red:internet/trigger
                fi
        fi
        sleep 10
done
exit 0
