#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    echo "Usage: `basename $0` <user>:<token>"
    exit
fi

user=$1

REPO=$(git config --get remote.origin.url | sed 's/git@github.com://g; s/.git//g;')
curl -i -u "$user" -X POST "https://api.github.com/repos/$REPO/dispatches" -d '{"event_type": "deploy"}'
