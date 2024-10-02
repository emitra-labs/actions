FROM golang:1.23.2 AS builder
WORKDIR /code
COPY . .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go build -o /code/app .

FROM gcr.io/distroless/base-debian12
WORKDIR /runner
COPY --from=builder /code/app ./app
EXPOSE 3000 4000
CMD ["./app"]
