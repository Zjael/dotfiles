#!/bin/bash

status=`systemctl is-active bluetooth.service`
if [ $status == "active" ]
then
	echo "%{F#0066ff} "
else
	echo "%{F#4dffffff} "
fi