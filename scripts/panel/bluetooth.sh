#!/bin/bash

status=`systemctl is-active bluetooth.service`
if [ $status == "active" ]
then
	echo "%{F#4dffffff} "
else
	echo "%{F#4dffffff} "
fi