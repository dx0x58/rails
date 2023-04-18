#!/bin/bash

set -e

services=("redis-server" "memcached")
#
# services=("postgresql" "mariadb" "redis-server" "memcached")

# Start services if not already running and wait for them to start
for service in "${services[@]}"
do
  service $service start
done

# extract the prefix from the path argument
# extract the prefix from the path argument
prefix=$(echo $1 | cut -d '/' -f1)
echo "Prefix: ${prefix}"

# build the test command to run
test_cmd="${prefix}/bin/test"
echo "Test command: ${test_cmd}"

# determine whether we're running a directory or a specific file
if [ -f "$1" ]; then
  # run the specified test file
  echo "Running specific test file: $1"
  test_cmd="${test_cmd} $1"
else
  # run the tests in the directory
  echo "Running tests in directory: ${prefix}/test"
  test_cmd="${test_cmd} ${prefix}/test"
fi

# execute the test command
echo "Final test command: ${test_cmd}"
exec $test_cmd
