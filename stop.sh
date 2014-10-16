#!/bin/bash
PIDFILE=/tmp/shortlink_app.pid
if [ -f $PIDFILE ]; then
  pid=`cat $PIDFILE`
  kill -9 $pid && rm $PIDFILE
else
  echo "PID file not exist"
fi
