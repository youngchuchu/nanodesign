FROM alpine:3.2
MAINTAINER joseph.schaeffer@autodesk.com

# USAGE: To build this instance:
#          docker build -t <identifier> .
#        where <identifier> is what you use as an identifier for the resulting container. Typically, 
#        a username / project name combination is reasonable for use here. 
# 
#        To run this instance (and be placed in a sh shell): 
#          docker run -t -i <identifier> /bin/sh
#
#        Note that the alpine minimal install does NOT have bash.

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --update python python-dev gfortran py-pip build-base py-numpy@testing && \
    apk del --purge python-dev gfortran py-pip build-base gcc g++ libgcc && \
    find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' +

ENV MODULE /nanodesign

RUN mkdir -p $MODULE

COPY ./ ${MODULE}/

# install the module
RUN cd $MODULE && python setup.py install

# set up the scripts directory
ENV APP /app
WORKDIR $APP

COPY scripts/ ${APP}/
