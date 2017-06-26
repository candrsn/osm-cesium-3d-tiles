FROM library/ubuntu:16.04
MAINTAINER Dmitry Kiselev <dmitry@endpoint.com>

RUN \
  apt-get update && \
  apt-get install -y \
    software-properties-common \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    parallel \
    osmctools && \
  rm -rf /var/lib/apt/lists/*

# Java for OSM2World
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install Node js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - ;\
    apt-get install -y nodejs

WORKDIR /opt

# Install OSM2World
RUN wget http://osm2world.org/download/files/latest/OSM2World-latest-bin.zip && \
    unzip OSM2World-latest-bin.zip -d osm2world && \
    rm OSM2World-latest-bin.zip

RUN wget https://github.com/AnalyticalGraphicsInc/3d-tiles-tools/archive/master.zip && \
    unzip master.zip && \
    mv 3d-tiles-tools-master 3d-tiles-tools && \
    cd 3d-tiles-tools/tools && \
    npm install && \
    rm /opt/master.zip && \
    cd /opt

RUN wget https://github.com/AnalyticalGraphicsInc/obj2gltf/archive/master.zip && \
    unzip master.zip && \
    mv obj2gltf-master obj2gltf && \
    cd obj2gltf && \
    npm install && \
    rm /opt/master.zip && \
    cd /opt

COPY scripts /opt/scripts

CMD [/bin/bash]

 
