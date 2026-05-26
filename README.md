# URL Redirect Service

A lightweight, containerized URL redirect service built on nginx. This service provides a simple HTTP redirect endpoint that forwards all traffic to a configured destination URL.

## Features

- **Simple URL redirection**: All HTTP requests are redirected to a configured URL
- **Health check endpoint**: Built-in `/_health` endpoint for monitoring
- **Security headers**: Includes security headers by default (X-Content-Type-Options, X-Frame-Options, Referrer-Policy)
- **Lightweight**: Alpine Linux-based Docker image (~50MB)
- **Configurable**: Uses environment variables for runtime configuration

## Quick Start

### Using Docker

```bash
docker build -t url-redirect .
docker run -p 8080:8080 -e REDIRECT_URL=https://example.com url-redirect
```

### Using Docker Compose

```yaml
version: '3'
services:
  url-redirect:
    build: .
    ports:
      - "8080:8080"
    environment:
      - REDIRECT_URL=https://example.com
```

## Configuration

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `REDIRECT_URL` | Yes | The URL to redirect all traffic to (trailing slashes are automatically stripped) |

## Usage

### Basic Redirect

```bash
# All requests to the service are redirected
curl -L http://localhost:8080/
# Redirects to: https://example.com
```

### Health Check

```bash
curl http://localhost:8080/_health
# Response: 200 OK with body "ok"
```

### Request Handling

- **Health checks**: Requests to `/_health` return 200 OK
- **All other requests**: Return HTTP 302 redirect to the configured `REDIRECT_URL`

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
- Security headers included in all responses:
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY`
  - `Referrer-Policy: no-referrer`

## Files

- `Dockerfile`: Container image definition
- `entrypoint.sh`: Startup script that configures Nginx from environment variables
- `nginx.conf.template`: Nginx configuration template with environment variable placeholders
- `LICENSE`: GNU General Public License v3

## License

This project is licensed under the GNU General Public License v3. See the LICENSE file for details.
