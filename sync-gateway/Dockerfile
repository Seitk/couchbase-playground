FROM couchbase/sync-gateway:2.1.0-community

COPY wait-for.sh /wait-for.sh
RUN chmod +x /wait-for.sh

COPY config/sync_gateway.json /etc/sync_gateway/config.json
