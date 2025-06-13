FROM rust:1.60 as builder

WORKDIR /app
COPY . .

RUN cargo build --release

FROM debian:bullseye-slim
WORKDIR /app

COPY --from=builder /app/target/release/actix-backend .
COPY .env .

CMD ["./actix-backend"]
