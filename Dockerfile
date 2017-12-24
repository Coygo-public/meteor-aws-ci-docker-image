FROM openjdk:8-jre

## env for the docker image after built
ENV METEOR_ALLOW_SUPERUSER true

# env to be used within this file. note there is also a .env
ARG AWS_CLI_VERSION_DOWNLOAD=1.14.16
ARG METEOR_VERSION_DOWNLOAD=1.6.0.1

# Install the AWS CLI,Python,Pip,AWS,git,,bsdtar(so meteor doesnt fail)
RUN apt-get update && \
  apt-get install -y python-dev build-essential git jq bsdtar && \
  curl -O https://bootstrap.pypa.io/get-pip.py && \
  python get-pip.py && \
  pip install awscli==$AWS_CLI_VERSION_DOWNLOAD && \
  pip install docker-compose && \
  ln -sf $(which bsdtar) $(which tar)
  #the above hack is in place https://github.com/coreos/bugs/issues/1095 

#install meteor
#this fails periodically with Directory renamed before its status could be extracted
RUN curl "https://install.meteor.com?release=$METEOR_VERSION_DOWNLOAD" | sh





