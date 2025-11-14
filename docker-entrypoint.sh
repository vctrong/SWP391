#!/bin/sh
set -e

# If PORT is set by Render, replace the default connector port in server.xml
if [ -n "$PORT" ]; then
  # Try common pattern; replace port="8080" with the runtime PORT
  sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml || true
fi

# exec the container's main process (Tomcat)
exec "$@"
