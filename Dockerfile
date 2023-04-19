FROM redhat/ubi9:latest

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

RUN tee /etc/yum.repos.d/elasticsearch.repo <<EOF \
[elasticsearch-7.x] \
name=Elasticsearch repository for 7.x packages \
baseurl=https://artifacts.elastic.co/packages/7.x/yum \
gpgcheck=1 \
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch \
enabled=1 \
autorefresh=1 \
type=rpm-md \
EOF

RUN dnf install --assumeyes java-11-openjdk
RUN dnf install --assumeyes logstash

RUN dnf install --assumeyes logstash
RUN systemctl start logstash
