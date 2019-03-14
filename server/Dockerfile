FROM couchbase:community

RUN wget -O- http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -
RUN wget -O/etc/apt/sources.list.d/couchbase.list \
      http://packages.couchbase.com/ubuntu/couchbase-ubuntu1204.list
RUN apt-get update \
    && apt-get -y install libcouchbase2-core libcouchbase2-libevent libcouchbase2-bin libcouchbase-dev