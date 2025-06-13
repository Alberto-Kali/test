FROM ubuntu:latest

WORKDIR /app

RUN apt-get update && apt-get install -y gettext

COPY . .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
