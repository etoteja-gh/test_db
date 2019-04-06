# MYSQL_DATABASE=test
# MYSQL_USERNAME=rcm_9ci_test
# MYSQL_ROOT_PASSWORD=999Foobar
# MYSQL_ROOT_HOST=%
# MYSQL_PORT=3306
# ACCEPT_EULA=Y
# SA_PASSWORD=999Foobar
# GRGIT_USER=0305edb725e4e9e308161755e13c0dd50f1d7e9d
# CIRCLE_BRANCH=release/9.9.x
# PWD=123456

FROM ubuntu:16.04

ARG MYSQL_SERVER_ADDRESS
ARG MSSQL_SERVER_ADDRESS
ARG DOCKERHUB_USER
ARG DOCKERHUB_PASSWORD
ENV MYSQL_SERVER_ADDRESS=${MYSQL_SERVER_ADDRESS}
ENV MSSQL_SERVER_ADDRESS=${MSSQL_SERVER_ADDRESS}
ENV DOCKERHUB_USER=${DOCKERHUB_USER}
ENV DOCKERHUB_PASSWORD=${DOCKERHUB_PASSWORD}

# Update packages and removev gabase dockers
# RUN apt-get && apt-get install -y --no-install-recommends apt-utils
# RUN apt-get remove docker docker-engine docker.io 

# Install and setup local
RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# Install docker
RUN apt-get install -y linux-image-extra-virtual 
RUN apt-get update -qq && apt-get install -qqy \
    curl \
    apt-transport-https \
    ca-certificates \
    lxc \
    iptables \
    dmsetup \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" | tee /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-cache policy docker-ce
RUN apt-get install -y docker-ce

ADD ./ninedb_build.sh /usr/local/bin/ninedb_build.sh
WORKDIR /data
RUN mkdir -p /data
COPY . /data/

RUN chmod +x /usr/local/bin/ninedb_build.sh
VOLUME /var/lib/docker

EXPOSE 3306 1433

ENTRYPOINT ["ninedb_build.sh"]
