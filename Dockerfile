FROM dockerfile/java:oracle-java8
MAINTAINER mihai.parv

ENV SERVIIO_WEBUI_VERSION 1.0.1-c
ENV SERVIIO_VERSION 1.4.1.1

RUN \
  cd /opt && \
  wget http://download.serviio.org/releases/serviio-$SERVIIO_VERSION-linux.tar.gz && \
  tar xvzf serviio-$SERVIIO_VERSION-linux.tar.gz && \
  rm -f serviio-$SERVIIO_VERSION-linux.tar.gz && \
  mv serviio-$SERVIIO_VERSION serviio

RUN \
  cd /opt/serviio && \
  wget http://kairoh.bitbucket.org/serviio-webui/dist/serviio-webui-unix-$SERVIIO_WEBUI_VERSION.tar.gz && \
  tar xvzf serviio-webui-unix-$SERVIIO_WEBUI_VERSION.tar.gz && \
  rm -f serviio-webui-unix-$SERVIIO_WEBUI_VERSION.tar.gz

WORKDIR /opt/serviio

VOLUME /opt/serviio/log

# serviio-webui requires TCP port 8123
EXPOSE 8123:8123/tcp

CMD [ "/opt/serviio/bin/serviio-webui.sh", "-Dserviio.remoteHost=$SERVIIO_TCP_ADDR" ]