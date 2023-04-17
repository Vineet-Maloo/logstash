FROM ubuntu:latest
RUN apt-get update
RUN curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

RUN echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-8.x.list
RUN apt-get update && apt-get install logstash
RUN apt install elasticsearch



