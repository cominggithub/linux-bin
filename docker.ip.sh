#!/bin/bash


for cid in `sudo docker ps -q`
do
echo ${cid}
#exec sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "${cid}"
sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "${cid}"
done
