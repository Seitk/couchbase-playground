#!/usr/bin/env bash
set -e

while ! { curl -X GET -u admin:password http://sync-gateway:4984 -H "accept: application/json"  -s | grep -q '"couchdb":"Welcome"'; }; do
  echo "is waiting for sync gateway to be ready..."
  sleep 9
done

exec "$@"
