#!/bin/sh
set -eu
crond
echo "GITHUB_TOKEN=${GITHUB_TOKEN}" >> /usr/local/share/jetzig.env
exec $@
