FROM golang:1.21.3-alpine AS build-mkcert

WORKDIR /usr/src/app

RUN apk add --no-cache git && \
    git clone https://github.com/FiloSottile/mkcert && \
    cd mkcert && \
    go build -o /bin/mkcert && \
    mkcert -install && \
    cp $(mkcert -CAROOT)/rootCA.pem /usr/src/app/rootCA.pem

FROM nginx:1.25.2-alpine

COPY --from=build-mkcert /bin/mkcert /bin/mkcert

COPY --from=build-mkcert /usr/src/app/rootCA.pem /usr/share/nginx/rootCA.pem

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

ENV DOMAIN="example.com example2.com"

CMD mkcert -key-file /usr/share/nginx/key.pem -cert-file /usr/share/nginx/cert.pem ${DOMAIN} && nginx -g "daemon off;"