FROM golang:1.9

COPY *.go /go/
COPY *.txt /go/
RUN apt-get update && apt-get install libcap-ng-utils
RUN go build -o /home/server
COPY test.sh /
RUN chmod +x /test.sh

CMD /home/server
EXPOSE 8080
