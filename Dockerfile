#FROM redhat/ubi9:latest
FROM centos
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum -y upgrade
RUN yum -y install wget
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
COPY logstash.repo /etc/yum.repos.d/
#RUN yum -y install java-11-openjdk
RUN yum -y install logstash


RUN  systemctl start logstash
RUN systemctl enable logstash
