#!/bin/bash
git clone https://github.com/EmbeddedAndroid/lava-docker.git -b las16-demo
git clone https://github.com/EmbeddedAndroid/ubuntu.git -b las16-dev
sudo docker build -t lava lava-docker/
sudo docker build -t zephyr-builder ubuntu/
sudo docker run -d -t -v /dev/bus/usb:/dev/bus/usb -v /dev/serial:/dev/serial -v /boot:/boot -v /lib/modules:/lib/modules -v /home/tyler/Dev/docker/lava/fileshare:/opt -p 80:80 -p 2022:22 -h lava-docker --name lava --privileged lava
sudo docker run -it -e ZEPHYR_OUTDIR="/var/www/html/zephyr" -v /home/tyler/Dev/docker/lava/fileshare:/opt -p 8000:8000 -h zephyr-ci --link lava zephyr-builder
sudo docker kill lava
sudo docker rm -f lava
