#!/bin/sh
set -e

# wait for bird control socket
until /usr/sbin/birdcl -s /srv/bird/bird.ctl show status; do
  echo "Waiting for BIRD to come online..."
  sleep 5
done

exec "$@"