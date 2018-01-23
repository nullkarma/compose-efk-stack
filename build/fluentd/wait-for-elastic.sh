#!/bin/bash

set -e

ELASTIC=$1
FLUENTD_CONF=$2
FLUENTD_OPT=$3

until curl -s -u fluentd:fluentd http://${ELASTIC}:9200 -I | grep -q "HTTP/1.1 200" ; do
    echo "waiting for elasticsearch"
    sleep 5
done
echo "elasticsearch is up. starting fluentd."

exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT
