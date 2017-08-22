#!/bin/bash
pac=$(checkupdates | wc -l)
aur=$(cower -u | wc -l)

check=$((pac + aur))
if [[ "$check" != "0" ]]
then
    echo "%{F#4ddbe6ec} "
    # echo "$pac %{F#5b5b5b}%{F-} $aur"
else
    echo "%{F#4dffffff} "
fi