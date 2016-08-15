FROM centos
MAINTAINER NarigaCDO "narigacdo@gmail.com"

RUN yum install -y yum-utils createrepo
RUN yum install -y centos-release-openstack-kilo
RUN yum clean all

ADD offline-repo /usr/bin/offline-repo
ADD offline-repo.conf /etc/offline-repo.conf

RUN chmod +x /usr/bin/offline-repo

CMD /usr/bin/offline-repo
