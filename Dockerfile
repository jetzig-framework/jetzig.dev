FROM alpine:latest AS build
RUN apk add jq curl tar xz
RUN curl --output /zig.tar.xz "$(curl -s 'https://ziglang.org/download/index.json' | jq -r '.master."x86_64-linux".tarball')"
RUN mkdir /zig
WORKDIR /zig
RUN tar -xf /zig.tar.xz
RUN mkdir /app
COPY . /app/
WORKDIR /app/
RUN /zig/zig-*/zig build install

FROM alpine:latest
RUN mkdir -p /app/public
COPY --from=build /app/zig-out/bin/jetzig.dev /app/server
COPY public/* /app/public/
COPY .env.production /app/.env
WORKDIR /app/
ENTRYPOINT ["./server"]
EXPOSE 8080
CMD ["--bind", "0.0.0.0", "--port", "8080"]
