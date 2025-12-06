#!/bin/sh
# Entrypoint script for Render deployment
# Maps Render's PORT to HTTP_PORT if HTTP_PORT is not set

# Render injects PORT automatically, but the server uses HTTP_PORT
# If HTTP_PORT is not set, use PORT from Render
if [ -z "$HTTP_PORT" ] && [ -n "$PORT" ]; then
    export HTTP_PORT="$PORT"
fi

# Default to 10000 if neither is set
export HTTP_PORT="${HTTP_PORT:-10000}"

# Execute the collab server
exec /app/collab "$@"

