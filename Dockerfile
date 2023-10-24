FROM golang:1.21.3-alpine AS build-mkcert

WORKDIR /usr/src/app

RUN apk add --no-cache git && \
    git clone https://github.com/FiloSottile/mkcert && \
    cd mkcert && \
    go build -o /bin/mkcert && \
    mkcert -install

FROM nginx:1.25.2-alpine

COPY --from=build-mkcert /bin/mkcert /bin/mkcert
COPY --from=build-mkcert /root/.local/share/mkcert/rootCA.pem /usr/share/nginx/ca.pem
COPY --from=build-mkcert /root/.local/share/mkcert/rootCA.pem /root/.local/share/mkcert/rootCA.pem
COPY --from=build-mkcert /root/.local/share/mkcert/rootCA-key.pem /root/.local/share/mkcert/rootCA-key.pem

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.template /etc/nginx/templates/10-variables.conf.template

EXPOSE 80 443

ENV DOMAIN="crop.crscd.net tw-dars.crop.crscd.net graph.crop.crscd.net"
ENV URL_CROP="crop:8080"
ENV URL_DARS="dars:8080"
ENV URL_GRAPH="graph:8080"

CMD mkcert -key-file /usr/share/nginx/key.pem -cert-file /usr/share/nginx/cert.pem ${DOMAIN} && envsubst < /etc/nginx/templates/10-variables.conf.template > /etc/nginx/nginx.conf && nginx -g "daemon off;"