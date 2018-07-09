FROM haproxy:1.8

MAINTAINER Caio Villela <villela.caio@gmail.com>

ENV CONSUL_TEMPLATE_VERSION=0.19.5

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y

RUN apt-get install -y gnupg2 ca-certificates curl telnet unzip vim
RUN apt-get install -y net-tools unbound

# Install Consul Template
ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /
RUN unzip /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip  && \
    mv /consul-template /usr/local/bin/consul-template && \
    rm -rf /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

RUN mkdir -p /haproxy /consul-template/config.d /consul-template/template.d
ADD config/ /consul-template/config.d/
ADD template/consul.tmpl /consul-template/template.d/

ADD reload.sh /reload.sh
ADD launch.sh /launch.sh
ADD sleep.sh /sleep.sh

RUN chmod +x /reload.sh /launch.sh /sleep.sh
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# For Debug Purpouses
#CMD ["/sleep.sh"]

CMD ["/launch.sh"]
