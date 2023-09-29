#!/bin/sh

if [ "$#" != "1" -o -z "$1" ]; then
    echo "Usage: $0 setup"
    echo "       $0 cleanup"
    exit 1
fi

if [ "$1" = "cleanup" ]; then
    sudo deluser rose
    sudo deluser steven
    sudo deluser zsvoboda
    sudo delgroup sales
    sudo delgroup product
    sudo delgroup zsvoboda
    exit $?
fi

if [ "$1" = "setup" ]; then
    sudo addgroup --gid 28100 product
    sudo addgroup --gid 28200 sales
    sudo addgroup --gid 20 zsvoboda

    sudo adduser --no-create-home --disabled-password  --uid 28110 --gid 28100 rose
    sudo adduser --no-create-home --disabled-password  --uid 28210 --gid 28200 steven
    sudo adduser --no-create-home --disabled-password  --uid 502 --gid 20 zsvoboda
    exit $?
fi


