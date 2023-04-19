FROM centos
COPY logstash.repo /etc/yum.repos.d/

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum -y upgrade
RUN yum -y install wget

RUN yum -y install java-11-openjdk
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch


RUN systemctl start logstash
RUN systemctl enable logstash
