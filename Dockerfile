FROM golang:1.21.3-alpine AS build-mkcert

WORKDIR /usr/src/app

RUN apk add --no-cache git && \
    git clone https://github.com/FiloSottile/mkcert && \
    cd mkcert && \
    go build -o /bin/mkcert

RUN mkcert -install && \
    cp $(mkcert -CAROOT)/rootCA.pem /usr/src/app/rootCA.pem

FROM nginx:1.25.2-alpine

COPY --from=build-mkcert /bin/mkcert /bin/mkcert

COPY --from=build-mkcert /usr/src/app/rootCA.pem /usr/share/nginx/rootCA.pem

CMD ["nginx", "-g", "daemon off;"]