#FROM redhat/ubi9:latest
FROM centos
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
COPY logstash.repo /etc/yum.repos.d/
RUN yum -y install java-11-openjdk
RUN yum -y install logstash


RUN  systemctl start logstash
RUN systemctl enable logstash
