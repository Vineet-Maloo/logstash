#FROM redhat/ubi9:latest
FROM centos
COPY logstash.repo /etc/yum.repos.d/

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum -y upgrade
RUN yum -y install wget
RUN wget https://artifacts.elastic.co/downloads/logstash/logstash-7.8.0.rpm
RUN yum -y install java-11-openjdk
RUN rpm -ivh logstash-7.8.0.rpm
RUN touch  /var/log/secure


COPY sshd.conf /etc/logstash/conf.d/
RUN chmod 640 /var/log/secure

RUN  systemctl start logstash
RUN systemctl enable logstash

