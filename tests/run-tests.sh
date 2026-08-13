#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PROJECT_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"
CONVERTER="$PROJECT_ROOT/src/convert-opencck-cidr.sh"
LAUNCHER="$PROJECT_ROOT/bin/convert-opencck-cidr.sh"
TUI_LAUNCHER="$PROJECT_ROOT/src/convert-opencck-cidr-ui.sh"
TUI_MAIN="$PROJECT_ROOT/src/ui/unix/main.sh"
UNIX_BUILD="$PROJECT_ROOT/build/unix/build.sh"
UNIX_LAUNCHER_TEMPLATE="$PROJECT_ROOT/build/unix/launcher.sh"
FIXTURE="$SCRIPT_DIR/fixtures/opencck-sample.json"
EXPECTED="$SCRIPT_DIR/fixtures/expected-output.json"
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/amnezia-opencck-tests.XXXXXX")
TEMP_DIR=$(CDPATH= cd -- "$TEMP_DIR" && pwd)

cleanup() {
    rm -rf -- "$TEMP_DIR"
}
trap cleanup EXIT HUP INT TERM

bash -n "$CONVERTER"
bash -n "$LAUNCHER"
bash -n "$TUI_LAUNCHER"
bash -n "$TUI_MAIN"
bash -n "$UNIX_BUILD"
bash -n "$UNIX_LAUNCHER_TEMPLATE"

for TUI_LIB in "$PROJECT_ROOT"/src/ui/unix/lib/*.sh; do
    bash -n "$TUI_LIB"
done

bash "$CONVERTER" \
    --input-path "$FIXTURE" \
    --output-path "$TEMP_DIR/source-result.json" \
    --language en

cmp -s "$EXPECTED" "$TEMP_DIR/source-result.json" \
    || { diff -u "$EXPECTED" "$TEMP_DIR/source-result.json"; exit 1; }

MACHINE_OUTPUT=$(bash "$CONVERTER" \
    --input-path "$FIXTURE" \
    --output-path "$TEMP_DIR/machine-result.json" \
    --language en \
    --machine-readable \
    2>"$TEMP_DIR/machine-stderr.txt")

EXPECTED_MACHINE_OUTPUT=$(printf \
    'status=success\nroute_count=3\noutput_path=%s' \
    "$TEMP_DIR/machine-result.json")

[ "$MACHINE_OUTPUT" = "$EXPECTED_MACHINE_OUTPUT" ] || {
    printf 'Unexpected machine-readable result:\n%s\n' "$MACHINE_OUTPUT" >&2
    exit 1
}

cmp -s "$EXPECTED" "$TEMP_DIR/machine-result.json" \
    || { diff -u "$EXPECTED" "$TEMP_DIR/machine-result.json"; exit 1; }

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
