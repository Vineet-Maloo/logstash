FROM redhat:latest

COPY logstash.repo /etc/yum.repos.d/

RUN yum -y install logstash

RUN cd /etc/pki/tls
RUN sudo openssl req -subj '/CN=ELK_server_fqdn/' -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt
