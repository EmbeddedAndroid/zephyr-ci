#!/bin/bash

git pull

if [ -d "lava-docker" ]; then
	cd lava-docker
	git pull
	cd ..
else
	git clone https://github.com/EmbeddedAndroid/lava-docker.git -b las16-demo
fi

if [ -d "ubuntu" ]; then
	cd ubuntu
	git pull
	cd ..
else
	git clone https://github.com/EmbeddedAndroid/ubuntu.git -b las16-dev
fi

sudo docker build -t lava lava-docker/
sudo docker build -t zephyr-builder ubuntu/
sudo docker run -d -t -v /dev:/dev/ -v /lib/modules:/lib/modules -p 80:80 -p 2022:22 -h lava-docker --name lava --privileged lava
sudo docker run -it -e ZEPHYR_OUTDIR="/var/www/html/zephyr" -p 8000:8000 -h zephyr-ci --link lava zephyr-builder
sudo docker kill lava
sudo docker rm -f lava
