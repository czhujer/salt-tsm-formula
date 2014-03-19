#!/bin/sh
# Startup script for tsm client acceptor daemon
#
# check /opt/tivoli/tsm/client/ba/bin/dsm.sys
# /opt/tivoli/tsm/client/ba/bin/dsm.opt
# description: Run dsmcad (or dsmc sched jobs)

#Source function library.
#. /etc/rc.d/init.d/functions

[ -f /opt/tivoli/tsm/client/ba/bin/dsmc ] || exit 0
[ -f /opt/tivoli/tsm/client/ba/bin/dsmcad ] || exit 0

prog="dsmcad"

export DSM_DIR=/opt/tivoli/tsm/client/ba/bin
export DSM_CONFIG=/opt/tivoli/tsm/client/ba/bin/dsm.opt

start() {
echo -n $"Starting $prog: "
cd $DSM_DIR
nohup $DSM_DIR/dsmcad &
RETVAL=$?
[ $RETVAL -eq 0 ] && touch /var/lock/subsys/dsmcad
return $RETVAL
}

stop() {
if test "x`pidof dsmcad`" != x; then
echo -n $"Stopping $prog: "
# killproc dsmcad
kill `pidof dsmcad`
echo
fi
RETVAL=$?
[ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/dsmcad
return $RETVAL
}

status() {
if [ -e /var/lock/subsys/dsmcad ]
 then
  echo "TSM client running"
 else
  echo "TSM client not running"
fi
}

case "$1" in
start)
start
;;

stop)
stop
;;

status)
status
;;
restart)
stop
start
;;
condrestart)
if test "x`pidof dsmcad`" != x; then
stop
start
fi
;;

*)
echo $"Usage: $0 {start|stop|restart|condrestart|status}"
exit 1

esac

exit 0


