FROM ubuntu:14.04
MAINTAINER Graham Bevan "graham.bevan@ntlworld.com"

ENV HOSTNAME foreman.conteiner
ENV FOREMANVER 1.11
ENV DEBIAN_FRONTEND noninteractive
ENV FOREOPTS --enable-foreman-compute-ovirt \
        --enable-foreman-compute-vmware \
        --enable-foreman-compute-libvirt \
        --enable-foreman-compute-openstack \
        --enable-foreman-plugin-docker \
        --enable-foreman-plugin-ansible \
        --foreman-proxy-tftp false \
        --foreman-admin-password nada@nada

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install ca-certificates wget software-properties-common && \
    wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
    dpkg -i puppetlabs-release-trusty.deb && \
    rm puppetlabs-release-trusty.deb && \
    apt-get install -y wget htop vim vim-puppet git && \
    echo "deb http://deb.theforeman.org/ trusty $FOREMANVER" > /etc/apt/sources.list.d/foreman.list && \
    echo "deb http://deb.theforeman.org/ plugins $FOREMANVER" >> /etc/apt/sources.list.d/foreman.list && \
    wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add - && \
    apt-get update && \
    apt-get install -y foreman-installer git sshpass vim && \
    echo "set modeline" > /root/.vimrc && \
    echo "export TERM=vt100" >> /root/.bashrc && \
    LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8 && \
    echo 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    rm -f /usr/share/foreman-installer/checks/hostname.rb && \
    export FACTER_fqdn="$HOSTNAME" && \
    echo "127.1.1.2  $HOSTNAME" >> /etc/hosts && \
    /usr/sbin/foreman-installer $FOREOPTS; \
    sed -i -e "s/START=no/START=yes/g" /etc/default/foreman

RUN ssh-keygen -f /usr/share/foreman/.ssh/id_rsa -t rsa -N ''
RUN echo -e "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null" > /usr/share/foreman/.ssh/config
RUN chown -R foreman. /usr/share/foreman/.ssh/

RUN git clone https://github.com/narigacdo/home-jab.git /etc/puppet/environments/home_jab/
RUN apt-get autoremove && apt-get autoclean && apt-get clean
EXPOSE 443
EXPOSE 8140
EXPOSE 8443

CMD /etc/init.d/puppet stop && \
    /etc/init.d/apache2 stop && \
    /etc/init.d/foreman stop && \
    /etc/init.d/postgresql stop && \
    echo "sleeping for postgresql to ensure stopped" && \
    sleep 30 && \
    /etc/init.d/postgresql start && \
    echo "sleeping for postgresql to ensure started" && \
    sleep 30 && \
    /etc/init.d/foreman start && \
    /etc/init.d/apache2 start && \
    /etc/init.d/puppet start && \
    /etc/init.d/foreman-proxy start && \
    /usr/sbin/cron && \
    /usr/sbin/foreman-rake db:seed && \
    service foreman-proxy restart && \
    hammer -u admin -p 'nada@nada' \
    proxy create --name $HOSTNAME --url https://$HOSTNAME:8443 || exit 0 && \
    echo "------- Chave publica para os computes libvirt -------" && \
    cat /usr/share/foreman/.ssh/id_rsa.pub && \
    echo "" && tail -f /var/log/foreman/production.log
