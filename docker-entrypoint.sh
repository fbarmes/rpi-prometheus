#!/bin/sh
set -e

#--
# start prometheus
/opt/prometheus/distrib/prometheus   \
  --config.file=/opt/prometheus/conf/prometheus.yml \
  --storage.tsdb.path=/opt/prometheus/data \
  --web.external-url http://${HOSTNAME}:9090/prometheus/
