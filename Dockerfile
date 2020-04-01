FROM ubuntu:18.04

ARG MAVEN_VERSION=3.6.3
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN apt-get update \
    && apt install -y git apt-transport-https ca-certificates curl wget software-properties-common gnupg \
# Install adoptopenjdk 8
    && wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
    && apt install -y adoptopenjdk-8-hotspot \
# Install maven (https://github.com/carlossg/docker-maven)
    && mkdir -p /usr/share/maven /usr/share/maven/ref \
    && curl -sSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
# Install nodejs/npm
    && curl -sSL https://deb.nodesource.com/setup_12.x | bash - \
    && apt install -y nodejs \
# Install docker ce
    && curl -sSL -o /tmp/docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-19.03.8.tgz \
    && tar -xzf /tmp/docker.tgz -C /tmp \
    && cp /tmp/docker/* /usr/bin \
    && rm -rf /tmp/docker* \
# Clean apt cache    
    && rm -rf /var/lib/apt/lists/*