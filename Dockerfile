#===============================================================================
# rpi-prometheus image
#===============================================================================
FROM fbarmes/rpi-alpine:latest


#-------------------------------------------------------------------------------
# setup system
#-------------------------------------------------------------------------------
RUN \
  # update system
  apk update && apk upgrade

#-------------------------------------------------------------------------------
# install prometheus
#-------------------------------------------------------------------------------
COPY bin/prometheus.tgz /tmp/prometheus.tgz
RUN \
  # create prometheus structure
  mkdir -p /opt/prometheus              &&\
  mkdir -p /opt/prometheus/distrib      &&\
  mkdir -p /opt/prometheus/conf         &&\
  mkdir -p /opt/prometheus/conf_ext     &&\
  mkdir -p /opt/prometheus/data         &&\
  #
  # install prometheus
  tar -zxf /tmp/prometheus.tgz --strip 1 -C /opt/prometheus/distrib  &&\
  rm /tmp/prometheus.tgz


#-------------------------------------------------------------------------------
# setup prometheus
#-------------------------------------------------------------------------------
COPY prometheus/conf/prometheus.yml /opt/prometheus/conf
COPY prometheus/conf_ext/node_exporter.yml /opt/prometheus/conf_ext

#-------------------------------------------------------------------------------
# wrap up
#-------------------------------------------------------------------------------
EXPOSE 9090
VOLUME /opt/prometheus/data
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

#-- install entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
