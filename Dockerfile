FROM golang:1.21.3-alpine AS MKCERT-BUILD

WORKDIR /app

RUN go get -u github.com/FiloSottile/mkcert && \
    cd src/github.com/FiloSottile/mkcert && \
    go build -o /bin/mkcert

CMD mkcert -install

FROM nginx:1.25.20-alpine

COPY /bin/mkcert /bin/mkcert