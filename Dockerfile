FROM registry.access.redhat.com/ubi8/ubi:8.7-1112

RUN yum -y install wget

RUN wget https://artifacts.elastic.co/downloads/logstash/logstash-8.5.1-x86_64.rpm
#RUN yum -y logstash-8.5.1-x86_64.rpm
RUN yum install 'dnf-command(logstash-8.5.1-x86_64.rpm)
