FROM ghcr.io/pelican-eggs/yolks:wine_latest

ENV DEBIAN_FRONTEND=noninteractive \
    SERVER_DIR=/server

RUN groupadd -g 1000 container 2>/dev/null || true \
 && useradd -u 1000 -g 1000 -m -s /bin/bash container 2>/dev/null || true

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl tar bash sudo \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /server \
 && chown -R container:container /server

WORKDIR /server

COPY start.sh /start.sh
RUN chmod +x /start.sh \
 && chown container:container /start.sh

USER container

ENTRYPOINT ["/start.sh"]
