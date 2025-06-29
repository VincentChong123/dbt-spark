#!/bin/bash

echo ">>> ENTRYPOINT SCRIPT TRIGGERED <<<"

export SPARK_DAEMON_JAVA_OPTS="$SPARK_DAEMON_JAVA_OPTS -Djava.net.preferIPv4Stack=true"

echo SPARK_DAEMON_JAVA_OPTS $SPARK_DAEMON_JAVA_OPTS

if [ -n "$WAIT_FOR" ]; then
  IFS=';' read -a HOSTPORT_ARRAY <<< "$WAIT_FOR"
  for HOSTPORT in "${HOSTPORT_ARRAY[@]}"
  do
    WAIT_FOR_HOST=${HOSTPORT%:*}
    WAIT_FOR_PORT=${HOSTPORT#*:}

    echo Waiting for $WAIT_FOR_HOST to listen on $WAIT_FOR_PORT...
    while ! nc -z $WAIT_FOR_HOST $WAIT_FOR_PORT; do echo sleeping; sleep 2; done
  done
fi

exec spark-submit "$@"
