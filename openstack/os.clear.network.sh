source ~/bin/openstack/demo.openrc.sh
echo "USER ${OS_USERNAME}"
echo "PW ${OS_PASSWORD}"
nova delete $(nova list | awk '{print $2}')
neutron router-interface-delete demo-router demo-subnet
neutron subnet-delete demo-subnet
neutron net-delete demo-net
neutron router-delete demo-router

source ~/bin/openstack/admin.openrc.sh
echo "USER ${OS_USERNAME}"
echo "PW ${OS_PASSWORD}"
neutron subnet-delete ext-subnet
neutron net-delete ext-net