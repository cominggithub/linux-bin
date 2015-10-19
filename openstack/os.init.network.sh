#!/bin/bash


#HOST_IP = $(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep -v '192.168.122')

source ~/bin/openstack/admin.openrc.sh
neutron net-create ext-net --router:external

neutron subnet-create ext-net --name ext-subnet --allocation-pool start=192.168.40.1,end=192.168.40.250 --disable-dhcp --gateway=192.168.40.254 192.168.40.0/24

source ~/bin/openstack/demo.openrc.sh

neutron net-create demo-net

neutron subnet-create demo-net --name demo-subnet --gateway 10.0.0.1 10.0.0.0/24 --dns_nameservers list=true 8.8.8.8 8.8.4.4

neutron router-create demo-router

neutron router-interface-add demo-router demo-subnet

neutron router-gateway-set demo-router ext-net

sudo ip route add 192.168.40.0/24 dev br-ex

sudo ip route add 10.0.0.0/24 via 192.168.40.1 dev br-ex


sudo ifconfig br-ex 192.168.40.25

#sudo ifconfig br-ex 192.168.40.53




#sudo ifconfig br-ex 192.168.40.54




#nova boot --flavor m1.tiny --image $(nova image-list | grep 'cirros-0.3.4-x86_64-uec\s' | awk '{print $2}') --nic net-id=$(neutron net-list | grep demo-net | awk '{print $2}') --num-instances 2 ccc

#nova boot --flavor m1.tiny --image $(nova image-list | grep 'cirros-0.3.4-x86_64-uec\s' | awk '{print $2}') --nic net-id=$(neutron net-list | grep demo-net | awk '{print $2}') --num-instances 2 aaa



