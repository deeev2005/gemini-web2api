# Multi-stage build for minimal container size and fast startup
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy module definition and code
COPY go.mod ./
COPY . ./

# Build standalone binary with optimization flags
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o go-gemini-web2api .

# Final minimal production container
FROM alpine:3.20

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /app

COPY --from=builder /app/go-gemini-web2api /app/go-gemini-web2api

# Expose default port (Render will bind to $PORT automatically)
EXPOSE 8081 10000

ENTRYPOINT ["/app/go-gemini-web2api"]
