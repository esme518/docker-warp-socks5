#
# Dockerfile for warp-socks5
#

FROM virb3/wgcf as wgcf

FROM alpine as source

ARG URL=https://api.github.com/repos/whyvl/wireproxy/releases/latest

WORKDIR /root

RUN set -ex \
    && if [ "$(uname -m)" == aarch64 ]; then \
           export PLATFORM='linux_arm64'; \
       elif [ "$(uname -m)" == x86_64 ]; then \
           export PLATFORM='linux_amd64'; \
       fi \
    && apk add --update --no-cache curl \
    && wget -O wireproxy.tar.gz $(curl -s $URL | grep browser_download_url | cut -d'"' -f4 | grep -i "$PLATFORM") \
    && tar xvf wireproxy.tar.gz

FROM alpine
COPY --from=wgcf /wgcf /usr/local/bin/wgcf
COPY --from=source /root/wireproxy /usr/local/bin/wireproxy

COPY docker-entrypoint.sh /entrypoint.sh
COPY warp-health-check.sh /warp-health-check.sh

RUN set -ex \
    && apk --update add --no-cache \
       curl \
    && rm -rf /tmp/* /var/cache/apk/*

WORKDIR /etc/wireproxy

EXPOSE 1080

ENTRYPOINT ["/entrypoint.sh"]

CMD ["wireproxy","-c","/etc/wireproxy/wireproxy.conf"]

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s \
  CMD ["/warp-health-check.sh"]
