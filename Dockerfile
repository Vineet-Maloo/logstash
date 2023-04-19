#FROM redhat/ubi9:latest
FROM centos
COPY logstash.repo /etc/yum.repos.d/

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum -y upgrade
RUN yum -y install wget
RUN wget https://artifacts.elastic.co/downloads/logstash/logstash-7.8.0.rpm
RUN rpm -ivh logstash-7.8.0.rpm


COPY ssd.conf /etc/logstash/conf.d/
RUN chmod 640 /var/log/secure

RUN  systemctl start logstash
RUN systemctl enable logstash

#RUN sudo yum -y install logstash

#RUN cd /etc/pki/tls
#RUN sudo openssl req -subj '/CN=ELK_server_fqdn/' -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt
#COPY 02-beats-input.conf /etc/logstash/conf.d/
#COPY 10-syslog-filter.conf  /etc/logstash/conf.d/
#COPY 30-elasticsearch-output.conf /etc/logstash/conf.d/
#RUN  systemctl start logstash
#RUN systemctl enable logstash
