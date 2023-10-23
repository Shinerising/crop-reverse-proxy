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

EXPOSE 80 443

ENV DOMAIN="example.com example2.com"

CMD mkcert -key-file /usr/share/nginx/key.pem -cert-file /usr/share/nginx/cert.pem ${DOMAIN} && nginx -g "daemon off;"