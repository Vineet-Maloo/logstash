FROM registry.access.redhat.com/ubi8/ubi:8.7-1112

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN sh -c "echo -e 'LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8' >> /etc/environment" && \
yum install -y glibc-langpack-en

RUN for iter in {1..10}; do \
export DEBIAN_FRONTEND=noninteractive && \
yum update -y && \
yum upgrade -y && \
yum install -y procps findutils tar gzip curl && \
    yum clean metadata && \
exit_code=0 && break || exit_code=$? && \
    echo "packaging error: retry $iter in 10s" && \
    yum clean all && \
yum clean metadata && \
sleep 10; done; \
    (exit $exit_code)


# Add Logstash itself.
RUN \
curl -Lo - https://artifacts.elastic.co/downloads/logstash/logstash-8.5.1-linux-$(arch).tar.gz | \
    tar zxf - -C /usr/share && \
    mv /usr/share/logstash-8.5.1 /usr/share/logstash && \
    chmod -R g=u /usr/share/logstash && \
    mkdir /licenses/ && \
    mv /usr/share/logstash/NOTICE.TXT /licenses/NOTICE.TXT && \
    mv /usr/share/logstash/LICENSE.txt /licenses/LICENSE.txt && \
find /usr/share/logstash -type d -exec chmod g+s {} \; && \
ln -s /usr/share/logstash /opt/logstash


WORKDIR /usr/share/logstash
ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/logstash/bin:$PATH

# Provide a minimal configuration, so that simple invocations will provide
# a good experience.
COPY config/pipelines.yml config/pipelines.yml
COPY config/log4j2.properties config/
COPY pipeline/default.conf pipeline/logstash.conf
# Ensure Logstash gets the correct locale by default.
COPY env2yaml/env2yaml /usr/local/bin/

# Place the startup wrapper script.
COPY bin/docker-entrypoint /usr/local/bin/
RUN chmod 0755 /usr/local/bin/docker-entrypoint && \
chmod 777 /usr/local/bin/env2yaml && \
/usr/share/logstash/bin/logstash-plugin install microsoft-logstash-output-azure-loganalytics



EXPOSE 9600 5044

RUN groupadd --gid 1000 logstash && \
    adduser --uid 1000 --gid 1000 \
       --home /usr/share/logstash --no-create-home \
      logstash &&\
chown --recursive logstash:logstash /usr/share/logstash/ && \
    chown -R logstash:root /usr/share/logstash && \
    chmod -R g=u /usr/share/logstash
USER 1000
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
