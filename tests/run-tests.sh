#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PROJECT_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"
CONVERTER="$PROJECT_ROOT/src/convert-opencck-cidr.sh"
LAUNCHER="$PROJECT_ROOT/bin/convert-opencck-cidr.sh"
FIXTURE="$SCRIPT_DIR/fixtures/opencck-sample.json"
EXPECTED="$SCRIPT_DIR/fixtures/expected-output.json"
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/amnezia-opencck-tests.XXXXXX")

cleanup() {
    rm -rf -- "$TEMP_DIR"
}
trap cleanup EXIT HUP INT TERM

bash -n "$CONVERTER"
bash -n "$LAUNCHER"

bash "$CONVERTER" \
    --input-path "$FIXTURE" \
    --output-path "$TEMP_DIR/source-result.json"

cmp -s "$EXPECTED" "$TEMP_DIR/source-result.json" \
    || { diff -u "$EXPECTED" "$TEMP_DIR/source-result.json"; exit 1; }

bash "$LAUNCHER" \
    --input-path "$FIXTURE" \
    --output-path "$TEMP_DIR/launcher-result.json"

cmp -s "$EXPECTED" "$TEMP_DIR/launcher-result.json" \
    || { diff -u "$EXPECTED" "$TEMP_DIR/launcher-result.json"; exit 1; }

FIRST_BYTES=$(od -An -tx1 -N3 "$TEMP_DIR/source-result.json" | tr -d ' \n')
[ "$FIRST_BYTES" != "efbbbf" ] || { echo 'Output JSON must be UTF-8 without BOM.' >&2; exit 1; }

if bash "$CONVERTER" \
    --source-url 'https://example.com/?format=amnezia&data=cidr4&site=test' \
    --output-path "$TEMP_DIR/invalid.json" >/dev/null 2>&1; then
    echo 'Invalid source domain was accepted.' >&2
    exit 1
fi

echo 'All Bash tests passed.'
