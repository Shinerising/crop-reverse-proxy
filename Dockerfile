FROM golang:1.21.3-alpine AS MKCERT_BUILD

WORKDIR /app

RUN go get -u github.com/FiloSottile/mkcert && \
    cd src/github.com/FiloSottile/mkcert && \
    go build -o /bin/mkcert && \
    mkcert -install && \
    cp $(mkcert -CAROOT)/rootCA.pem /app/rootCA.pem

FROM nginx:1.25.20-alpine

COPY MKCERT_BUILD:/bin/mkcert /bin/mkcert
COPY MKCERT_BUILD:/app/rootCA.pem /usr/share/nginx/rootCA.pem