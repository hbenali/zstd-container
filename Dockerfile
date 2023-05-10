# First image to build the binary
FROM alpine:3.18.0 as builder
RUN apk --no-cache add make gcc libc-dev zstd curl
ARG ZSTD_VERSION=1.5.0
RUN curl -sL https://github.com/facebook/zstd/releases/download/v${ZSTD_VERSION}/zstd-${ZSTD_VERSION}.tar.zst -o zstd.tar.zst
RUN unzstd zstd.tar.zst
RUN tar xf zstd.tar
RUN mkdir /pkg && cd /zstd-${ZSTD_VERSION} && make && make DESTDIR=/pkg install

# Second minimal image to only keep the built binary
FROM alpine:3.18.0
ARG ZSTD_VERSION=1.5.0
# Copy the built files
COPY --from=builder /pkg /
# Copy the license as well
RUN mkdir -p /usr/local/share/licenses/zstd
COPY --from=builder /zstd-${ZSTD_VERSION}/LICENSE /usr/local/share/licences/zstd/
# Just run `zstd` if no other command is given
CMD ["/usr/local/bin/zstd"]
