#!/bin/bash

sh ./update-harmony.sh
docker build -t anthonyyang/harmony-docker .
rm -rf ./harmony-master
