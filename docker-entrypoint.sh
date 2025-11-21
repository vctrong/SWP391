#!/bin/sh
set -e

CONF="/usr/local/tomcat/conf/server.xml"

# Normalize line endings (remove CR) to avoid Windows CRLF issues
if [ -f "$CONF" ]; then
  tr -d '\r' < "$CONF" > /tmp/server.xml && mv /tmp/server.xml "$CONF" || true
fi

# Disable Tomcat remote shutdown port (prevent "Invalid shutdown command" warnings)
# Replace occurrences of port="8005" (the default shutdown port) with port="-1"
if grep -q 'port="8005"' "$CONF"; then
  echo "[entrypoint] Disabling Tomcat shutdown port (8005 -> -1)"
  sed -i 's/port="8005"/port="-1"/' "$CONF" || true
fi

# Use Render's provided PORT env var (fallback to 8080 if not set)
PORT="${PORT:-8080}"

# Replace first occurrence of port="NNNN" for the HTTP Connector with the PORT value.
# The "0," prefix makes sed replace only the first match (GNU sed). If not available, fallback to global replace.
if grep -q 'port="8080"' "$CONF"; then
  echo "[entrypoint] Setting Tomcat HTTP Connector port to ${PORT}"
  sed -i "0,/port=\"[0-9]\+\"/s//port=\"${PORT}\"/" "$CONF" 2>/dev/null || sed -i "s/port=\"[0-9]\+\"/port=\"${PORT}\"/" "$CONF" || true
else
  # try replacing the first numeric port occurrence just in case connector differs
  sed -i "0,/port=\"[0-9]\+\"/s//port=\"${PORT}\"/" "$CONF" 2>/dev/null || true
fi

echo "[entrypoint] Starting Tomcat on port ${PORT}..."
exec "$@"