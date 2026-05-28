#!/bin/sh
set -eu

if [ -n "${NGROK_AUTHTOKEN:-}" ]; then
  ngrok config add-authtoken "$NGROK_AUTHTOKEN"
fi

exec "$@"
