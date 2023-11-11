FROM golang:1.21-alpine AS build

WORKDIR /build

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o /go/bin/catgpt

FROM gcr.io/distroless/static-debian12:latest-amd64

EXPOSE 8080 9090

USER nobody:nobody

COPY --from=build /go/bin/catgpt /catgpt

CMD [ "/catgpt" ]
