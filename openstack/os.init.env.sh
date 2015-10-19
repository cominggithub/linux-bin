#!/bin/bash
source ~/bin/openstack/demo
wget http://download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img

glance image-create --disk-format=qcow2 --container-format=bare --name="ubuntu-precise" < trusty-server-cloudimg-amd64-disk1.img





nova delete $(nova list | awk '{print $2}')

nova boot --flavor m1.tiny --image $(nova image-list | grep 'ubuntu-precise\s' | awk '{print $2}') --nic net-id=$(neutron net-list | grep private | awk '{print $2}') --num-instances 2 test
