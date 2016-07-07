#!/bin/sh
set -eo pipefail

# wait for bird control socket
until /usr/sbin/birdcl -s /srv/bird/bird.ctl show status; do
  echo "Waiting for BIRD to come online..."
  sleep 5
done

# export eth0 IP env variable
export IP=`ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`

exec "$@"