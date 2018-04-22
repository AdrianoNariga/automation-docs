#!/bin/bash
configure_corosync(){
cat > /etc/corosync/corosync.conf << EOF
compatibility: whitetank
aisexec{
	user: root
	group: root
}
service {
	ver: 1
	name: pacemaker
	use_mgmtd: no
	use_logd: no
}
totem {
	version: 2
	secauth: on
	threads: 0
	cluster_name: HA
	token: 50000
	token_retransmits_before_loss_const: 10
	join: 60
	consensus: 7500
	vstype: none
	max_messages: 20
	clear_node_high_bit: yes
	send_join: 45
	rrp_mode: none
	interface {
		ringnumber: 0
		bindnetaddr: $1
		broadcast: yes
		mcastaddr: 239.255.1.1
		mcastport: 5405
		ttl: 1
	}
}
amf {
	mode disabled
}
quorum {
	provider: corosync_vetequorum
	expected: 1
	two_nodes: 2
}
logging {
	fileline: off
	to_stderr: no
	to_logfile: yes
	logfile: /var/log/cluster/corosync.log
	to_syslog: yes
	debug: off
	timestamp: on
	logger_subsys {
		subsys: AMF
		debug: off
		tags: enter|leave|trace1|trace2|trace3|trace4|trace6
	}
}
EOF
}

yum install epel-release wget -y
wget -O /etc/yum.repos.d/ha-clustering.repo \
	https://download.opensuse.org/repositories/network:ha-clustering:Stable/CentOS_CentOS-6/network:ha-clustering:Stable.repo
yum install corosync openais cman pacemaker -y
configure_corosync $(ip -o -4 a s eth0 | awk '{print $4}' | cut -d \/ -f 1)
#corosync-keygen 
