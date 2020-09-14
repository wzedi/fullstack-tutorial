#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    echo "Usage: `basename $0` <user>:<token>"
    exit
fi

user=$1

curl -i -u "$user" -X POST "https://api.github.com/repos/wzedi/fullstack-tutorial/dispatches" -d '{"event_type": "deploy"}'
