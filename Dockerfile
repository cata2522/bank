
# Build step
FROM golang:1.16-alpine3.13 as builder
WORKDIR /app

COPY . /app/
RUN go build -o main main.go

# Run stage
FROM alpine:3.13
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate.linux-amd64/migrate ./migrate
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration

EXPOSE 8080
ENTRYPOINT [ "/app/start.sh" ]
CMD [ "/app/main" ]