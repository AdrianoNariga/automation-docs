#!/bin/bash

FLAVOR_DEFAULT=$(nova flavor-list | grep -iv name |  awk '{print $4}' | xargs  | awk '{print $3}')
write_template(){
cat > /root/heat_test.yaml << EOF
heat_template_version: 2013-05-23

description: Template simples para deploy de uma instancia

parameters:
  flavor:
    type: string
    default: $FLAVOR_DEFAULT
  imagem:
    type: string
    default: cirros image
  network:
    type: string
    default: $ID

resources:
  my_000:
    type: OS::Nova::Server
    properties:
      flavor: { get_param: flavor }
      image: { get_param: imagem }
      networks:
        - port: { get_resource: server_port }

  server_port:
    type: OS::Neutron::Port
    properties:
      network_id: { get_param: network }

  float_ip:
    type: OS::Nova::FloatingIP
    properties:
      pool: publica
  associate_float_ip:
    type: OS::Nova::FloatingIPAssociation
    properties:
      floating_ip: { get_resource: float_ip }
      server_id: { get_resource: my_000 }
EOF
}

create_project(){
	PUB_ID=$(neutron net-show publica | grep id | head -n1 | awk '{print $4}')
	PROJECT_id=$(openstack project create --description "Openstack Test" ops-test | grep id | awk '{print $4}')
	openstack user create --password nada@nada user_test
	openstack role add --project ops-test --user user_test heat_stack_owner

	export OS_USERNAME=user_test
	export OS_TENANT_NAME=ops-test
	export OS_PASSWORD=nada@nada

	neutron router-create router
	neutron router-gateway-set router $PUB_ID

	neutron net-create rede
	neutron subnet-create rede 192.168.0.0/24 --enable-dhcp --gateway 192.168.0.1 --name sub-internal
	ID_SUB=$(neutron subnet-list | grep 192.168.0 | awk '{print $2}')
	neutron router-interface-add router $ID_SUB

	ID=$(neutron net-list | grep rede | awk '{print $2}')
}


create_project
#write_template

#heat --os-endpoint-type internalURL stack-create cirrosOS -f heat_test.yaml
