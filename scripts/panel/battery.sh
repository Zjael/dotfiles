#!/bin/bash

getinfo() {
  echo $(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "$1" | awk -v patt="$1" -F'[[:space:]][[:space:]]+' '{ print $3 }')
}

power=$(getinfo "percentage")
state=$(getinfo "state")
output=""

if [ "$state" == "charging" ]; then
  output="$output"
fi

power=$(grep -Po "(?!%)\d+" <<< "$power")
if [ "$power" -le 10 ]; then
  output="%{F#fffa5e5b}$output%$power%{F}"
elif [ "$power" -le "30" ]; then
  output="$output $power%"
elif [ "$power" -le "60" ]; then
  output="$output $power%"
elif [ "$power" -le "80" ]; then
  output="$output $power%"
else
  output="%{F#ff16c98d}$output $power%%{F}"
fi

echo "$output"