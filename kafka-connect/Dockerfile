FROM confluentinc/cp-kafka-connect

WORKDIR /src

ARG CONNECT_BOOTSTRAP_SERVERS
ARG CONNECT_API_KEY
ARG CONNECT_API_SECRET

ARG CONNECT_COUCHBASE_ADDRESS=server
ARG CONNECT_COUCHBASE_BUCKET=main-bucket
ARG CONNECT_COUCHBASE_USER=admin
ARG CONNECT_COUCHBASE_PASSWORD=password
ARG CONNECT_COUCHBASE_SINK_TOPIC=dev-couchbase-sink-philip-3
ARG CONNECT_COUCHBASE_SOURCE_TOPIC=dev-couchbase-source

COPY wait-for.sh /wait-for.sh
RUN chmod +x /wait-for.sh

COPY plugins/ /usr/local/share/kafka/plugins
COPY config/ ./

RUN sed -i "s/CONNECT_BOOTSTRAP_SERVERS/$CONNECT_BOOTSTRAP_SERVERS/" cluster.properties \
    && sed -i "s/CONNECT_API_KEY/$CONNECT_API_KEY/" cluster.properties \
    && sed -i "s/CONNECT_API_SECRET/$CONNECT_API_SECRET/" cluster.properties \
    && sed -i "s/CONNECT_COUCHBASE_ADDRESS/$CONNECT_COUCHBASE_ADDRESS/" couchbase-source.properties \
    && sed -i "s/CONNECT_COUCHBASE_BUCKET/$CONNECT_COUCHBASE_BUCKET/" couchbase-source.properties \
    && sed -i "s/CONNECT_COUCHBASE_USER/$CONNECT_COUCHBASE_USER/" couchbase-source.properties \
    && sed -i "s/CONNECT_COUCHBASE_PASSWORD/$CONNECT_COUCHBASE_PASSWORD/" couchbase-source.properties \
    && sed -i "s/CONNECT_COUCHBASE_SOURCE_TOPIC/$CONNECT_COUCHBASE_SOURCE_TOPIC/" couchbase-source.properties \
    && sed -i "s/CONNECT_COUCHBASE_ADDRESS/$CONNECT_COUCHBASE_ADDRESS/" couchbase-sink.properties \
    && sed -i "s/CONNECT_COUCHBASE_BUCKET/$CONNECT_COUCHBASE_BUCKET/" couchbase-sink.properties \
    && sed -i "s/CONNECT_COUCHBASE_USER/$CONNECT_COUCHBASE_USER/" couchbase-sink.properties \
    && sed -i "s/CONNECT_COUCHBASE_PASSWORD/$CONNECT_COUCHBASE_PASSWORD/" couchbase-sink.properties \
    && sed -i "s/CONNECT_COUCHBASE_SINK_TOPIC/$CONNECT_COUCHBASE_SINK_TOPIC/" couchbase-sink.properties

RUN chmod 777 /usr/local/share/kafka/plugins/*

CMD ["connect-standalone", "cluster.properties"]
