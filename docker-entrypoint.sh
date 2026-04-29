#!/bin/sh
set -e

exec duckdb -ui "$@"
