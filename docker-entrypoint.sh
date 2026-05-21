#!/bin/sh
set -e

if [ -n "$BACKEND_URL" ]; then
  cat > /usr/share/nginx/html/assets/config/runtime-config.json <<EOF
{"backendUrl": "$BACKEND_URL"}
EOF
fi

exec nginx -g "daemon off;"
