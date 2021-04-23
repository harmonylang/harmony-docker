#!/bin/bash

sh ./update-harmony.sh
docker build --rm -t anthonyyang/harmony-docker .
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
rm -rf ./harmony-master

