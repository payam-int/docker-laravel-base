#!/bin/bash

php-fpm &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start fpm: $status"
  exit $status
fi

nginx
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi

while sleep 10; do
  ps aux |grep nginx |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep php-fpm |grep -q -v grep
  PROCESS_2_STATUS=$?
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "nginx stopped."
    exit 1
  fi
  if [ $PROCESS_2_STATUS -ne 0 ]; then
    echo "php-fpm is stopped."
    exit 1
  fi
done
