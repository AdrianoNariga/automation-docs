## Usado como base https://github.com/gbevan/ubuntu-foreman
# Quick Start
# cd directory/dockerfile
# docker build -t dono/image_name .
# docker run -ti -h foreman.conteiner \
#     -v /home/alrodrigues/puppet_modules:/etc/puppet/environments/puppet_modules \
#     -p 443:443 -p 8443:8443 -p 8140:8140 nariga/foreman:11.2
# variavel HOSTNAME deve ser a mesma para o dockerfile e o conteiner
FROM ubuntu:14.04
MAINTAINER NarigaCDO "narigacdo@gmail.com"

ENV HOSTNAME foreman.conteiner
ENV FOREMANVER 1.13
ENV DEBIAN_FRONTEND noninteractive
ENV FOREOPTS --enable-foreman-compute-vmware \
        --enable-foreman-compute-libvirt \
        --enable-foreman-compute-openstack \
        --enable-foreman-plugin-docker \
        --enable-foreman-plugin-ansible \
        --foreman-proxy-tftp false \
        --enable-puppet \
        --puppet-listen=true \
        --puppet-show-diff=true \
        --puppet-server-envs-dir=/etc/puppetlabs/code/environments

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install ca-certificates wget && \
    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb && \
    dpkg -i puppetlabs-release-pc1-trusty.deb && \
    rm puppetlabs-release-pc1-trusty.deb && \
    echo "deb http://deb.theforeman.org/ trusty $FOREMANVER" > /etc/apt/sources.list.d/foreman.list && \
    echo "deb http://deb.theforeman.org/ plugins $FOREMANVER" >> /etc/apt/sources.list.d/foreman.list && \
    wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add - && \
    apt-get install -y software-properties-common git sshpass && \
    apt-get update && \
    apt-get install -y foreman-installer && \
    echo "export TERM=vt100" >> /root/.bashrc && \
    LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8 && \
    echo 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    rm -f /usr/share/foreman-installer/checks/hostname.rb && \
    export FACTER_fqdn="$HOSTNAME" && \
    echo "`ifconfig eth0 | grep Bcast | awk '{print $2}' | cut -d : -f 2` $HOSTNAME" >> /etc/hosts && \
    /usr/sbin/foreman-installer $FOREOPTS; \
    puppet cert generate $HOSTNAME; \
    /usr/sbin/foreman-installer $FOREOPTS; \
    sed -i -e "s/START=no/START=yes/g" /etc/default/foreman; \
    sed -i.bak "s/certname*.*/certname = $HOSTNAME/g" /etc/puppetlabs/puppet/puppet.conf

RUN ssh-keygen -f /usr/share/foreman/.ssh/id_rsa -t rsa -N ''
ADD config /usr/share/foreman/.ssh/config
RUN chown -R foreman. /usr/share/foreman/.ssh/
ADD cli_config.yml /etc/hammer/cli_config.yml
RUN rm /root/.hammer/cli.modules.d/foreman.yml
RUN ln -s /etc/hammer/cli_config.yml /root/.hammer/cli.modules.d/foreman.yml
ADD scripts/pos-deploy /root/pos-deploy

RUN apt-get autoremove && apt-get autoclean && apt-get clean
EXPOSE 80
EXPOSE 443
EXPOSE 8140
EXPOSE 8443

CMD /etc/init.d/puppet stop && \
    /etc/init.d/apache2 stop && \
    /etc/init.d/foreman stop && \
    /etc/init.d/postgresql stop && \
    echo "sleeping for postgresql to ensure stopped" && \
    sleep 60 && \
    /etc/init.d/postgresql start && \
    echo "sleeping for postgresql to ensure started" && \
    sleep 60 && \
    /etc/init.d/foreman start && \
    /etc/init.d/apache2 start && \
    /etc/init.d/puppet start && \
    /etc/init.d/foreman-proxy start && \
    /usr/sbin/cron && \
    /usr/sbin/foreman-rake db:seed && \
    service foreman-proxy restart && \
    old_pass=$(grep password /etc/hammer/cli_config.yml | cut -d \' -f 2) && \
    new_pass=$(foreman-rake permissions:reset | awk '{print $6}') && \
    echo "Password admin $new_pass" && \
    /usr/bin/hammer -u admin -p $new_pass \
       proxy create --name $HOSTNAME --url https://$HOSTNAME:8443 ; \
    echo "------- Chave publica para os computes libvirt -------" ; \
    sed -i -e "s/$old_pass/$new_pass/g" /etc/hammer/cli_config.yml ; \
    for i in $(hammer proxy list | egrep -v '(^ID|^-)' | awk '{print $1}') ; \
    do hammer proxy import-classes --id $i ; done ; \
    cat /usr/share/foreman/.ssh/id_rsa.pub ; \
    echo "" ; tail -f /var/log/foreman/production.log
