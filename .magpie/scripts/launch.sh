#!/bin/sh
# Builds MacNTop and launches it detached in the background, then asserts
# it's still alive a couple of seconds later. `kill -0` on a dead PID exits
# non-zero, and with `set -e` that fails this step honestly — a real crash-
# on-launch regression, not a harness quirk.
set -e
swift build
nohup .build/debug/MacNTop >/tmp/macntop.log 2>&1 &
echo $! > /tmp/macntop.pid
sleep 2
kill -0 "$(cat /tmp/macntop.pid)"
echo "MacNTop launched, pid $(cat /tmp/macntop.pid), still alive after 2s"
