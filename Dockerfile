FROM golang:1.21.3-alpine AS MKCERT_BUILD

WORKDIR /usr/src/app

RUN go get -u github.com/FiloSottile/mkcert && \
    cd src/github.com/FiloSottile/mkcert && \
    go build -o /bin/mkcert

RUN mkcert -install && \
    cp $(mkcert -CAROOT)/rootCA.pem /usr/src/app/rootCA.pem

FROM nginx:1.25.2-alpine

CMD ["nginx", "-g", "daemon off;"]