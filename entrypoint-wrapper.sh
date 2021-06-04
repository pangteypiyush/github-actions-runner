#!/usr/bin/dumb-init /bin/bash

exec dockerd --host=tcp://0.0.0.0:2375 --host='unix:///var/run/docker.sock' &

source /entrypoint.sh
