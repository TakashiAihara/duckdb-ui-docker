#!/bin/bash
set -e

# tail -f /dev/null keeps stdin open so duckdb does not exit on EOF
tail -f /dev/null | duckdb -ui "$@" &
DUCKDB_PID=$!

trap 'kill "$DUCKDB_PID" 2>/dev/null' TERM INT

# Wait for DuckDB UI to be ready
until (echo > /dev/tcp/localhost/4213) 2>/dev/null; do
    sleep 1
done

# Forward 0.0.0.0:4123 → [::1]:4213 (foreground, keeps container alive)
exec socat TCP-LISTEN:4123,bind=0.0.0.0,fork,reuseaddr TCP6:[::1]:4213
