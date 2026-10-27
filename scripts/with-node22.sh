#!/usr/bin/env sh
# Run a command under Node 22. Catalyst's default pipeline image ships Node 18 and an `images:` entry would
# need registry credentials, so fetch Node 22 from npm (the `node` package) instead.
# Usage: scripts/with-node22.sh <command> [args...]
set -eu

dir="${NODE22_DIR:-${TMPDIR:-/tmp}/node22}"
if [ ! -x "$dir/node_modules/.bin/node" ]; then
  npm install --prefix "$dir" --no-audit --no-fund --loglevel=error node@22
fi

PATH="$dir/node_modules/.bin:$PATH"
export PATH

major=$(node -p "process.versions.node.split('.')[0]")
if [ "$major" -lt 22 ]; then
  echo "Node 22+ required, got $(node -v)" >&2
  exit 1
fi
echo "using node $(node -v)"

exec "$@"
