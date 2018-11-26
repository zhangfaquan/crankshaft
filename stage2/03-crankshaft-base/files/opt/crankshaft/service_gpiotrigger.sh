#!/bin/bash

source /opt/crankshaft/crankshaft_default_env.sh
source /opt/crankshaft/crankshaft_system_env.sh

IGN_COUNTER=0

# check gpio pin if activated
if [ $REARCAM_PIN -ne 0 ] || [ $IGNITION_PIN -ne 0 ] || [ $DAYNIGHT_PIN -ne 0 ]; then
    while true; do
        if [ $REARCAM_PIN -ne 0 ]; then
            REARCAM_GPIO=`gpio -g read $REARCAM_PIN`
            if [ $REARCAM_GPIO -ne 1 ] ; then
                if [ ! -f /tmp/rearcam_enabled ]; then
                    touch /tmp/rearcam_enabled
                fi
            else
                if [ -f /tmp/rearcam_enabled ]; then
                    rm /tmp/rearcam_enabled
                fi
            fi
        fi
        if [ $DAYNIGHT_PIN -ne 0 ]; then
            DAYNIGHT_GPIO=`gpio -g read $DAYNIGHT_PIN`
            if [ $DAYNIGHT_GPIO -ne 1 ] ; then
                if [ ! -f /tmp/night_mode_enabled ]; then
                    touch /tmp/night_mode_enabled
                fi
            else
                if [ -f /tmp/night_mode_enabled ]; then
                    rm /tmp/night_mode_enabled
                fi
            fi
        fi
        if [ $IGNITION_PIN -ne 0 ]; then
            IGNITION_GPIO=`gpio -g read $IGNITION_PIN`
            if [ $IGNITION_GPIO -ne 0 ] ; then
                IGN_COUNTER=$((IGN_COUNTER+1))
                if [ $IGN_COUNTER -gt $IGNITION_DELAY ]; then
                    if [ ! -f /tmp/android_device ] && [ ! -f /tmp/btdevice ]; then
                        if [ ! -f /tmp/external_exit ]; then
                            touch /tmp/external_exit
                        fi
                    else
                        IGN_COUNTER=0
                    fi
                fi
            else
                IGN_COUNTER=0
            fi
        fi
        sleep 1
    done
fi

exit 0
