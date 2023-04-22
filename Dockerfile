FROM registry.access.redhat.com/ubi8/ubi:8.7-1112

#RUN yum -y install locales 
#RUN localectl set-locale LANG=en_US.UTF-8
#RUN locale-gen 'en_US.UTF-8' 

# Provide a non-root user to run the process.
RUN groupadd --gid 1000 logstash && \
    adduser --uid 1000 --gid 1000 \
       --home /usr/share/logstash --no-create-home \
      logstash

# Add Logstash itself.
RUN \
curl -Lo - https://artifacts.elastic.co/downloads/logstash/logstash-8.5.1-linux-$(arch).tar.gz | \
    tar zxf - -C /usr/share && \
    mv /usr/share/logstash-8.5.1 /usr/share/logstash && \
chown --recursive logstash:logstash /usr/share/logstash/ && \
    chown -R logstash:root /usr/share/logstash && \
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
COPY config/logstash-full.yml config/logstash.yml
COPY config/log4j2.properties config/
COPY pipeline/default.conf pipeline/logstash.conf
RUN chown --recursive logstash:root config/ pipeline/
# Ensure Logstash gets the correct locale by default.
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
COPY env2yaml/env2yaml /usr/local/bin/
RUN chmod 777 /usr/local/bin/env2yaml


# Place the startup wrapper script.
COPY bin/docker-entrypoint /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint

USER 1000

EXPOSE 9600 5044

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
