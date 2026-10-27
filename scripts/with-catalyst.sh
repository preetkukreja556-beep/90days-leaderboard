#!/usr/bin/env sh
# Run a command with a pinned Catalyst CLI on PATH so pipeline deploys use a repeatable version.
# Run it under scripts/with-node22.sh so the CLI uses Node 22.
# Usage: sh scripts/with-node22.sh sh scripts/with-catalyst.sh <command> [args...]
set -eu

version="${CATALYST_CLI_VERSION:-1.29.0}"
dir="${CATALYST_CLI_DIR:-${TMPDIR:-/tmp}/catalyst-cli}"
if [ ! -x "$dir/node_modules/.bin/catalyst" ]; then
  npm install --prefix "$dir" --no-audit --no-fund --loglevel=error "zcatalyst-cli@$version"
fi

PATH="$dir/node_modules/.bin:$PATH"
export PATH
echo "using catalyst $(catalyst --version 2>&1 | tail -1)"

exec "$@"
