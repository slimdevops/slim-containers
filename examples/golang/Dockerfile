FROM golang:1.14.2

WORKDIR /go/app

ADD . .

RUN go get .

CMD ["go", "run", "main.go"]
