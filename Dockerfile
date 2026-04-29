FROM debian:trixie-slim

ARG TARGETARCH
ARG DUCKDB_VERSION=v1.5.2

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        unzip \
        socat \
    && rm -rf /var/lib/apt/lists/*

RUN case "$TARGETARCH" in \
        "amd64") ARCH="amd64" ;; \
        "arm64") ARCH="arm64" ;; \
        *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac \
    && curl -fsSL "https://github.com/duckdb/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-${ARCH}.zip" -o /tmp/duckdb.zip \
    && unzip /tmp/duckdb.zip -d /tmp \
    && mv /tmp/duckdb /usr/local/bin/duckdb \
    && rm /tmp/duckdb.zip \
    && chmod +x /usr/local/bin/duckdb

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV DUCKDB_UI_NO_BROWSER=1

HEALTHCHECK --interval=5s --timeout=5s --start-period=30s --retries=10 \
    CMD curl -s http://localhost:4213/ -o /dev/null || exit 1

EXPOSE 4123

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["docker-entrypoint.sh"]
