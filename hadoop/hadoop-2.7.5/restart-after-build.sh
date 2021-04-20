#!/bin/bash
S='\033[0;30m[debug] '
E='\033[0m'

docker-compose -p hadoop down && ./start-after-build.sh