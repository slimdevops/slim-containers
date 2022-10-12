FROM golang:1.19.2

WORKDIR /go/app

ADD . .

RUN go get .

CMD ["go", "run", "main.go"]
