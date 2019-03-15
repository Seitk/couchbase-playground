#!/usr/bin/env bash
set -e

sync_gateway_config_file_path=/etc/sync_gateway/config.json
sync_gateway_config_template_file_path="${sync_gateway_config_file_path}.template"

couchbase_server_url=`cat $sync_gateway_config_file_path | grep '"server":' | grep -o '"http://.*"' | sed 's/"//g'`

while ! { curl -X GET -u admin:password http://server:8091/pools/default/buckets -H "accept: application/json" -s | grep -q '"status":"healthy"'; }; do
  echo "is waiting for couchbase to be ready..."
  sleep 10
done

exec "$@"
