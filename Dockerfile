FROM nginx:bookworm

ARG TARGETARCH
ARG DUCKDB_VERSION=v1.5.2

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        unzip \
        openssl \
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

COPY nginx.conf /etc/nginx/nginx.conf
COPY docker-entrypoint.sh /docker-entrypoint-duckdb.sh
RUN chmod +x /docker-entrypoint-duckdb.sh

ENV DUCKDB_UI_NO_BROWSER=1

EXPOSE 8080 8443

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint-duckdb.sh"]
