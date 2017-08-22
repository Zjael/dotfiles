#!/bin/bash

connection=$(nmcli device 2>/dev/null | tail -n +2 | grep -w "ethernet" | awk '{print $3}')

if [ -z "$connection" ]; then
  exit 0
fi

if [ "$connection" = "connecting" ]
  echo "%{F#678bdc} "
elif [ "$connection" = "connected" ]
  echo "%{F#e88e2c} "
else
  exit 0
fi
