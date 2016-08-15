FROM centos
MAINTAINER NarigaCDO "narigacdo@gmail.com"

RUN yum install -y yum-utils createrepo epel-release
#RUN yum install -y centos-release-openstack-kilo
RUN yum install -y centos-release-openstack-liberty
RUN yum -y localinstall http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
RUN yum -y install centos-release-ceph-hammer
RUN yum clean all

ADD docker.repo /etc/yum.repos.d/docker.repo
ADD offline-repo /usr/bin/offline-repo
ADD offline-repo.conf /etc/offline-repo.conf

RUN chmod +x /usr/bin/offline-repo

CMD /usr/bin/offline-repo
