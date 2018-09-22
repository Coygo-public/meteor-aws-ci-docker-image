FROM frolvlad/alpine-glibc


# env to be used within this file. note there is also a .env
ARG AWS_CLI_VERSION_DOWNLOAD=1.16.19
ARG METEOR_VERSION_DOWNLOAD=1.7.0.5
# ARG DOCKER_COMPOSE_DOWNLOAD=1.20.1
# ARG DOCKER_VERSION=18.02.0-r0
# Install the AWS CLI,Python,Pip,AWS,git,docker,meteor-dependencies (libstdc,g++,make).
# Install gcc, since its a node-gyp dependency and in case you need to rebuild during npm installs
# note: g++ triples the size of the image :( total is around 200MB
RUN \
	mkdir -p /app && \
	apk -Uuv add --no-cache \
  bash git jq curl openssh libsecret-dev \
  python py-pip \
  docker \
  gcc g++ make && \
	pip install \
  awscli==${AWS_CLI_VERSION_DOWNLOAD} \
  docker-compose && \
	apk --purge -v del py-pip

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



