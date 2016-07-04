#!/bin/sh
set -e

# wait for bird control socket
while [ ! -f /srv/bird/bird.ctl ]; do
  echo "Waiting for BIRD to come online..."
  sleep 5
done

exec "$@"