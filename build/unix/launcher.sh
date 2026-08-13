#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

export PATH="$SCRIPT_DIR/runtime:$PATH"

exec bash "$SCRIPT_DIR/runtime/src/convert-opencck-cidr-ui.sh"
