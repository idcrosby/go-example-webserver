FROM golang:1.9

COPY *.go /go/
RUN go build -o /server

CMD /server
EXPOSE 8080
