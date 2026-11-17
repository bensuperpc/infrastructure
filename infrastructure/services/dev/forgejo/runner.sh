#!/bin/sh
# Starts forgejo-runner once forgejo_runner_register has registered FORGEJO_RUNNER_SECRET in Forgejo.
set -eu

trap 'exit 0' TERM INT
until [ -f /data/registered ]; do
    sleep 5
done

# The runner's uuid is the first 16 characters of the secret, hex-encoded
hex=$(printf %.16s "$FORGEJO_RUNNER_SECRET" | od -An -tx1 | tr -d ' \n')
uuid=$(printf %s "$hex" | sed -E 's/^(.{8})(.{4})(.{4})(.{4})(.{12})$/\1-\2-\3-\4-\5/')

umask 077
printf %s "$FORGEJO_RUNNER_SECRET" > /data/token
sed "s/@UUID@/$uuid/" /config/runner.yml > /data/config.yml
exec forgejo-runner daemon --config /data/config.yml
