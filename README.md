# URL Redirect Service

A lightweight, containerized URL redirect service built on nginx. It forwards all incoming HTTP requests to a configured destination URL.

## How It Works

On startup, `entrypoint.sh` reads the `REDIRECT_URL` environment variable, strips any trailing slash, and uses `envsubst` to render `nginx.conf.template` into a live nginx config. nginx then issues a `302` redirect to that URL for every incoming request. The original request path is not forwarded. A dedicated `/_health` location returns `200 OK` and is excluded from access logs.

## Features

- **Simple URL redirection**: All HTTP requests are redirected to a configured URL
- **Health check endpoint**: Built-in `/_health` endpoint for monitoring
- **Security headers**: Includes `X-Content-Type-Options`, `X-Frame-Options`, and `Referrer-Policy` by default
- **Lightweight**: Alpine Linux-based Docker image (~50MB)
- **Configurable**: Runtime configuration via environment variables

## Quick Start

### Using the pre-built image

```bash
docker run --rm -p 8080:8080 -e REDIRECT_URL=https://example.com ghcr.io/ffflorian/url-redirect
```

### Building locally

```bash
docker build -t url-redirect .
docker run --rm -p 8080:8080 -e REDIRECT_URL=https://example.com url-redirect
```

### Using Docker Compose

```yaml
services:
  url-redirect:
    image: ghcr.io/ffflorian/url-redirect
    ports:
      - "8080:8080"
    environment:
      - REDIRECT_URL=https://example.com
    restart: unless-stopped
```

## Configuration

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `REDIRECT_URL` | Yes | The destination URL. Trailing slashes are stripped automatically. |

## Usage

### Verify the redirect

```bash
curl -i http://localhost:8080/
# HTTP/1.1 302 Moved Temporarily
# Location: https://example.com
```

### Follow the redirect

```bash
curl -L http://localhost:8080/any/path
# Follows the redirect to https://example.com
```

Note: the original request path is not appended to `REDIRECT_URL`. All paths redirect to the same destination.

### Health check

```bash
curl -i http://localhost:8080/_health
# HTTP/1.1 200 OK
#
# OK
```

### Request handling

| Path | Response |
|------|----------|
| `/_health` | `200 OK` - health check, not logged |
| Everything else | `302` redirect to `REDIRECT_URL` |

## Network Configuration

- **Port**: 8080
- **Protocol**: HTTP
- **Timeouts**:
  - Client body timeout: 10s
  - Client header timeout: 10s
  - Keep-alive timeout: 15s
  - Send timeout: 10s

## Security

- Server tokens disabled (no nginx version disclosure)
- Security headers on all responses:
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY`
  - `Referrer-Policy: no-referrer`

## Files

- `Dockerfile`: Container image definition
- `entrypoint.sh`: Startup script that configures nginx from environment variables
- `nginx.conf.template`: nginx configuration template with environment variable placeholders
- `LICENSE`: GNU General Public License v3

## License

This project is licensed under the GNU General Public License v3. See the [LICENSE](./LICENSE) file for details.
