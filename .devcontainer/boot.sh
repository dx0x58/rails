#!/bin/bash

set -e

services=("postgresql" "mariadb" "redis-server" "memcached")

# Start services if not already running and wait for them to start
for service in "${services[@]}"
do
  if [ "$(systemctl is-active $service)" != "active" ]; then
    echo "Starting $service service..."
    sudo service $service start
  else
    echo "$service service is already running"
  fi
  until [ "$(systemctl is-active $service)" == "active" ]; do
    sleep 1
  done
done

# Start a bash shell
echo "Starting bash shell..."
exec /bin/bash
