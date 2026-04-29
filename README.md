# duckdb-ui-docker

Docker image for [DuckDB](https://duckdb.org/) with the built-in web UI.

## Images

| Registry | Image |
|---|---|
| GitHub Container Registry | `ghcr.io/takashiaihara/duckdb-ui` |
| Docker Hub | `takashiaihara/duckdb-ui` |

## Platforms

- `linux/amd64`
- `linux/arm64`

## Usage

### In-memory database

```bash
docker run -p 4123:4123 ghcr.io/takashiaihara/duckdb-ui:latest
```

Open http://localhost:4123 in your browser.

### Persistent database

```bash
docker run -p 4123:4123 -v $(pwd)/data:/data ghcr.io/takashiaihara/duckdb-ui:latest /data/mydb.duckdb
```

### Docker Compose

```yaml
services:
  duckdb-ui:
    image: ghcr.io/takashiaihara/duckdb-ui:latest
    ports:
      - "4123:4123"
    volumes:
      - ./data:/data
    command: /data/mydb.duckdb
```

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `DUCKDB_UI_NO_BROWSER` | `1` | Suppress automatic browser launch |

## Versions

| Component | Version |
|---|---|
| DuckDB | v1.5.2 |
| Base image | debian:trixie-slim (Debian 13) |
