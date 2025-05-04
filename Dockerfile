FROM alpine:latest AS build
RUN apk add jq curl tar xz
RUN curl --output /zig.tar.xz "$(curl -s 'https://ziglang.org/download/index.json' | jq -r '.master."x86_64-linux".tarball')"
RUN mkdir /zig
WORKDIR /zig
RUN tar -xf /zig.tar.xz
RUN mkdir /app
COPY . /app/
WORKDIR /app/
RUN /zig/zig-*/zig build -Denvironment=production install

FROM alpine:latest
RUN mkdir -p /app/public
COPY --from=build /app/zig-out/bin/jetzig.dev /app/server
COPY public/* /app/public/
COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/crontab.cron /etc/cron.d/jetzig.cron
COPY docker/get_releases.py /usr/local/lib/get_releases.py
RUN apk add python3 py3-requests
WORKDIR /app/
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/app/server", "--bind", "0.0.0.0", "--port", "8080"]
