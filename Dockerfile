# VERSION 0.1
# DOCKER-VERSION  0.7.3
# AUTHOR:         Pat Wood <pat.wood@efi.com>
# DESCRIPTION:    Image with docker-registry project and dependecies
# TO_BUILD:       docker build -rm -t registry .
# TO_RUN:         docker run -p 5000:5000 registry

# Alpine Linux Python image
FROM frolvlad/alpine-python2

COPY . /docker-registry
RUN apk update && apk add /docker-registry/swig-3.0.2-r0.apk
RUN apk add gcc python-dev openssl-dev libc-dev xz-dev

COPY ./config/boto.cfg /etc/boto.cfg

# Install core
RUN pip install /docker-registry/depends/docker-registry-core

# Install registry
RUN pip install file:///docker-registry#egg=docker-registry[bugsnag,newrelic,cors]

# Clean everything up
# Image has to be "flattened" for this to have any real effect
RUN apk del gcc swig python-dev
RUN rm -rf /usr/share/man /usr/share/doc /usr/include /lib/*.a /usr/lib/*.a /root/.cache \
  /docker-registry/swig-3.0.2-r0.apk /docker-registry/.git /docker-registry/depends \
  /usr/lib/debug/lib /lib/apk /var/cache/apk

ENV DOCKER_REGISTRY_CONFIG /docker-registry/config/config_sample.yml
ENV SETTINGS_FLAVOR dev

EXPOSE 5000

CMD ["docker-registry"]
