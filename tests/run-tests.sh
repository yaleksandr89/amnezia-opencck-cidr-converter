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
    --output-path "$TEMP_DIR/source-result.json" \
    --language en

cmp -s "$EXPECTED" "$TEMP_DIR/source-result.json" \
    || { diff -u "$EXPECTED" "$TEMP_DIR/source-result.json"; exit 1; }

bash "$LAUNCHER" \
    --input-path "$FIXTURE" \
    --output-path "$TEMP_DIR/launcher-result.json" \
    --language ru

cmp -s "$EXPECTED" "$TEMP_DIR/launcher-result.json" \
    || { diff -u "$EXPECTED" "$TEMP_DIR/launcher-result.json"; exit 1; }

bash "$CONVERTER" --language en --help | grep -q '^Usage:'
bash "$CONVERTER" --language ru --help | grep -q '^Использование:'

FIRST_BYTES=$(od -An -tx1 -N3 "$TEMP_DIR/source-result.json" | tr -d ' \n')
[ "$FIRST_BYTES" != "efbbbf" ] || { echo 'Output JSON must be UTF-8 without BOM.' >&2; exit 1; }

if bash "$CONVERTER" \
    --source-url 'https://example.com/?format=amnezia&data=cidr4&site=test' \
    --output-path "$TEMP_DIR/invalid.json" \
    --language en >/dev/null 2>&1; then
    echo 'Invalid source domain was accepted.' >&2
    exit 1
fi

echo 'All Bash tests passed.'
