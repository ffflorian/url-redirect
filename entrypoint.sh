#!/bin/sh

set -e

: "${REDIRECT_URL:?REDIRECT_URL environment variable is required}"

# Strip trailing slash to prevent nginx from treating the URL as having a URI
# component, which causes it to rewrite the request path
REDIRECT_URL="${REDIRECT_URL%/}"
export REDIRECT_URL

envsubst '${REDIRECT_URL}' < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"
