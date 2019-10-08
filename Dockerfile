FROM alpine 

STOPSIGNAL 9
  
RUN apk --update --no-cache add --virtual build-dependencies build-base && \
    cd /tmp && \
    wget https://github.com/joan2937/pigpio/archive/master.zip && \
    unzip -qq master.zip && \
    cd pigpio-master && \
    make && \
    sed -i 's/ldconfig/ldconfig \/usr\/local/g' Makefile && \
    make install && \
    apk del build-dependencies && \
    rm -rf /tmp/* && \
    apk --no-cache add tini

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
