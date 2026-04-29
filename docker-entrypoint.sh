#!/bin/bash
set -e

# Generate self-signed SSL cert if not externally mounted
if [ ! -f /etc/ssl/private/nginx-duckdb.key ] || [ ! -f /etc/ssl/certs/nginx-duckdb.pem ]; then
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx-duckdb.key \
        -out /etc/ssl/certs/nginx-duckdb.pem \
        -subj "/CN=localhost" 2>/dev/null
fi

# Start DuckDB UI in background; pass any extra args (e.g. a .db file path)
duckdb -ui "$@" &
DUCKDB_PID=$!

# Clean up DuckDB when the container is stopped
cleanup() {
    kill "$DUCKDB_PID" 2>/dev/null || true
}
trap cleanup TERM INT

# Nginx as the main foreground process (Docker monitors this PID)
exec nginx -g 'daemon off;'
