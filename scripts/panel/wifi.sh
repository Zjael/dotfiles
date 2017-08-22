#!/bin/bash

current=$(nmcli device wifi 2>/dev/null | tail -n +2 | grep -P "^\*")

# no connection
if [ -z "$current" ]; then
  echo "%{F#4dffffff} "
  exit 0
fi

signal=$(awk -F'[[:space:]]{2,}' '{ print $6 }' <<< "$current")
ssid=$(awk -F'[[:space:]]{2,}' '{ print $2 }' <<< "$current")

if [ "$signal" -le "30" ]; then
  output=""
elif [ "$signal" -le "70" ]; then
  output=""
else
  output=""
fi

# output="$output $ssid"
echo "$output"
