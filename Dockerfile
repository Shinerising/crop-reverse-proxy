FROM golang:1.21.3-alpine AS build-mkcert

WORKDIR /usr/src/app

RUN apk add --no-cache git && \
    git clone https://github.com/FiloSottile/mkcert && \
    cd mkcert && \
    go build -o /bin/mkcert && \
    mkcert -install && \
    gzip -k /root/.local/share/mkcert/rootCA.pem

FROM nginx:1.25.2-alpine

COPY --from=build-mkcert /bin/mkcert /bin/mkcert
COPY --from=build-mkcert /root/.local/share/mkcert/rootCA.pem /root/.local/share/mkcert/rootCA-key.pem /root/.local/share/mkcert/
COPY --from=build-mkcert /root/.local/share/mkcert/rootCA.pem.gz /usr/share/nginx/ca.pem.gz

COPY nginx.conf conf.template /etc/nginx/

EXPOSE 80 443

ENV DOMAIN="crop.crscd.net tw-dars.crop.crscd.net graph.crop.crscd.net"
ENV URL_API="api:8080"
ENV URL_CROP="crop:8080"
ENV URL_DARS="dars:8080"
ENV URL_GRAPH="graph:8080"

CMD mkcert -key-file /usr/share/nginx/key.pem -cert-file /usr/share/nginx/cert.pem ${DOMAIN} && envsubst '${URL_API},${URL_CROP},${URL_DARS},${URL_GRAPH}' < /etc/nginx/conf.template > /etc/nginx/variables.conf && nginx -g "daemon off;"