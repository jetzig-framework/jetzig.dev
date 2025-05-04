#!/bin/sh
set -eu
/etc/init.d/cron start
echo "GITHUB_TOKEN=${GITHUB_TOKEN}" >> /usr/local/share/jetzig.env
exec $@
