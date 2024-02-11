#!/bin/bash 

if [ $(whoami) = 'root' ]; then
    echo "you are root"
elif [ $(whoami) = 'shubhro' ]; then
    echo "shubhro"
else
    echo "you are not root"
fi
