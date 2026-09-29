#!/bin/sh
# Runs on the deploy host. The CI key in ~/.ssh/authorized_keys may run only this script
# (command="..."), with the commit to deploy as its SSH command: `ssh host <sha>`.
# Publishes public/ at that commit into Caddy's root for mirattic.com.
set -eu
repo="$HOME/Documents/mirattic-main"
www=/opt/homebrew/var/www/mirattic
sha="${SSH_ORIGINAL_COMMAND:-${1:-}}"
case "$sha" in
  *[!0-9a-f]* | "") echo "usage: deploy.sh <commit sha>" >&2; exit 2 ;;
esac
git -C "$repo" fetch -q origin
git -C "$repo" checkout -q --detach "$sha"
mkdir -p "$www"
rsync -a --delete "$repo/public/" "$www/"
curl -fsS -o /dev/null https://mirattic.com/ && echo "deployed $sha"
