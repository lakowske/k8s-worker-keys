FROM gliderlabs/alpine:3.4

MAINTAINER Seth Lakowske <lakowske@gmail.com>

ENV WORKER_IP=192.168.11.101
ENV WORKER_FQDN=uw1
ENV K8S_SERVICE_IP=192.168.11.100
ENV CERTS=/certs
ENV KEYDIR=$CERTS/uw1

RUN apk-install openssl
ADD ./worker-openssl.cnf /
CMD echo $MASTER_HOST && \
mkdir -p $KEYDIR && \
/usr/bin/openssl  genrsa -out $KEYDIR/$WORKER_FQDN-worker-key.pem 2048 && \
/usr/bin/openssl req -new -key $KEYDIR/$WORKER_FQDN-worker-key.pem -out $KEYDIR/$WORKER_FQDN-worker.csr -subj "/CN=$WORKER_FQDN" -config /worker-openssl.cnf && \
/usr/bin/openssl x509 -req -in $KEYDIR/$WORKER_FQDN-worker.csr -CA $CERTS/ca.pem -CAkey $CERTS/ca-key.pem -CAcreateserial -out $KEYDIR/$WORKER_FQDN-worker.pem -days 365 -extensions v3_req -extfile /worker-openssl.cnf


