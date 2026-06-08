#!/bin/sh

set -e

: "${REDIRECT_URL:?REDIRECT_URL environment variable is required}"

case "$REDIRECT_URL" in
  http://*|https://*) ;;
  *) echo "REDIRECT_URL must start with http:// or https://" >&2; exit 1 ;;
esac

# Strip trailing slash to prevent nginx from treating the URL as having a URI
# component, which causes it to rewrite the request path
REDIRECT_URL="${REDIRECT_URL%/}"
export REDIRECT_URL

envsubst '${REDIRECT_URL}' < /tmp/nginx.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"
