#!/bin/sh
set -e

# Normalize line endings (remove CR) to avoid Windows CRLF issues
if [ -f /usr/local/tomcat/conf/server.xml ]; then
  tr -d '\r' < /usr/local/tomcat/conf/server.xml > /tmp/server.xml && mv /tmp/server.xml /usr/local/tomcat/conf/server.xml || true
fi

if [ -n "$PORT" ]; then
  # Replace first occurrence of port="NNNN" with port="$PORT"
  sed -i "0,/port=\"[0-9]\+\"/s//port=\"${PORT}\"/" /usr/local/tomcat/conf/server.xml || \
  sed -i "s/port=\"[0-9]\+\"/port=\"${PORT}\"/" /usr/local/tomcat/conf/server.xml || true
fi

exec "$@"
