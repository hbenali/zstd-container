# First image to build the binary
FROM alpine:3.18.2 as builder
RUN apk --no-cache add make gcc libc-dev zip curl
ARG ZSTD_CHANNEL=dev
RUN curl -sL https://github.com/facebook/zstd/archive/refs/heads/${ZSTD_CHANNEL}.zip -o zstd.tar.zip
RUN unzip zstd.tar.zip
RUN mkdir /pkg && cd /zstd-${ZSTD_CHANNEL} && make && make DESTDIR=/pkg install

# Second minimal image to only keep the built binary
FROM alpine:3.18.2
ARG ZSTD_CHANNEL=dev
# Copy the built files
COPY --from=builder /pkg /
# Copy the license as well
RUN mkdir -p /usr/local/share/licenses/zstd
COPY --from=builder /zstd-${ZSTD_CHANNEL}/LICENSE /usr/local/share/licences/zstd/
# Just run `zstd` if no other command is given
CMD ["--help"]
ENTRYPOINT ["/usr/local/bin/zstd"]
