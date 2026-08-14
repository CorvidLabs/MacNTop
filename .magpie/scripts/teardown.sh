#!/bin/sh
# Deliberately no `set -e`: teardown must succeed even if launch already
# failed or the process already died, so a broken run still cleans up.
if [ -f /tmp/macntop.pid ]; then
	kill "$(cat /tmp/macntop.pid)" 2>/dev/null || true
	rm -f /tmp/macntop.pid
fi
echo "teardown complete"
