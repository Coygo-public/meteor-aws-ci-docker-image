FROM frolvlad/alpine-oraclejdk8:slim


# env to be used within this file. note there is also a .env
ARG AWS_CLI_VERSION_DOWNLOAD=1.14.16
ARG METEOR_VERSION_DOWNLOAD=1.6.0.1
ARG DOCKER_COMPOSE_DOWNLOAD=1.18.0
ARG DOCKER_VERSION=17.10.0-r0
# Install the AWS CLI,Python,Pip,AWS,git,docker,meteor-dependencies (libstdc,g++,make).
# Install gcc, since its a node-gyp dependency and in case you need to rebuild during npm installs
# note: g++ triples the size of the image :( total is around 200MB
RUN \
	mkdir -p /app && \
	apk -Uuv add \
  bash git jq curl openssh \
  python py-pip \
  docker=${DOCKER_VERSION} \
  gcc g++ make && \
	pip install \
  awscli==${AWS_CLI_VERSION_DOWNLOAD} \
  docker-compose==${DOCKER_COMPOSE_DOWNLOAD} && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

# install libstdc so node version doesn't yell at us anymore
RUN curl -fL https://raw.githubusercontent.com/orctom/alpine-glibc-packages/master/usr/lib/libstdc++.so.6.0.21 -o /usr/lib/libstdc++.so.6

#create a non-root user
RUN adduser -D -u 1000 meteor

#install meteor ~600 MB
USER meteor
RUN curl "https://install.meteor.com?release=$METEOR_VERSION_DOWNLOAD" | sh

# add meteor to the path after docker is built
ENV PATH="/home/meteor/.meteor:${PATH}"
# cd into /app folder
WORKDIR /app



