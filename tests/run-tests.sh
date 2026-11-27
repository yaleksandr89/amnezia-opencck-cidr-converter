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
TEMP_DIR=$(CDPATH= cd -P -- "$TEMP_DIR" && pwd -P)

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

HELP_EN=$(bash "$CONVERTER" --language en --help)
HELP_RU=$(bash "$CONVERTER" --language ru --help)
grep -q '^Usage:' <<< "$HELP_EN"
grep -q '^Использование:' <<< "$HELP_RU"

FIRST_BYTES=$(od -An -tx1 -N3 "$TEMP_DIR/source-result.json" | tr -d ' \n')
[ "$FIRST_BYTES" != "efbbbf" ] || { echo 'Output JSON must be UTF-8 without BOM.' >&2; exit 1; }

if bash "$CONVERTER" \
    --source-url 'https://example.com/?format=amnezia&data=cidr4&site=test' \
    --output-path "$TEMP_DIR/invalid.json" \
    --language en >/dev/null 2>&1; then
    echo 'Invalid source domain was accepted.' >&2
    exit 1
fi

export TMPDIR="$TEMP_DIR"
cd -- "$TEMP_DIR"

assert_no_temp_files() {
    local artifacts
    artifacts=$(find "$TEMP_DIR" \( -name '.amnezia-opencck-output.*' -o -name 'amnezia-opencck-count.*' \))
    if [ -n "$artifacts" ]; then
        printf 'Temporary conversion files remain:\n%s\n' "$artifacts" >&2
        exit 1
    fi
}

expect_failure() {
    local description=$1 diagnostic=$2 status=0
    shift 2
    bash "$CONVERTER" --machine-readable "$@" > failure-stdout.txt 2> failure-stderr.txt || status=$?
    if [ "$status" -ne 1 ] || [ -s failure-stdout.txt ] || ! grep -Fq -- "$diagnostic" failure-stderr.txt; then
        printf 'Unexpected failure result for %s (exit %s):\n' "$description" "$status" >&2
        cat failure-stdout.txt failure-stderr.txt >&2
        exit 1
    fi
    assert_no_temp_files
}

LITERAL_INPUT='payload= [source].json'
LITERAL_OUTPUT='[output dir]/result [test].json'
mkdir -- '[output dir]'
cp -- "$FIXTURE" "$LITERAL_INPUT"
expect_failure 'same input and output' 'Input and output must be different files.' \
    -i "$LITERAL_INPUT" -o "$LITERAL_INPUT" -l en
expect_failure 'absolute output alias' 'Входной и выходной файлы должны различаться.' \
    -i "./$LITERAL_INPUT" -o "$TEMP_DIR/$LITERAL_INPUT" -l ru
cmp "$FIXTURE" "$LITERAL_INPUT"

printf 'prior result\000\377\n' > sentinel
cp sentinel "$LITERAL_OUTPUT"
printf '[]\n' > empty-list.json
expect_failure 'empty list with prior output' 'No valid CIDR entries were found.' \
    -i empty-list.json -o "$LITERAL_OUTPUT" -l en
cmp sentinel "$LITERAL_OUTPUT"
expect_failure 'empty list with no prior output' 'Не удалось получить ни одной корректной CIDR-записи.' \
    -i empty-list.json -o absent.json -l ru
[ ! -e absent.json ]

EXPECT_DIR_ENTRIES=$(ls -A -- '[output dir]')
expect_failure 'directory output' 'The output path must refer to an ordinary file' \
    -i "$LITERAL_INPUT" -o '[output dir]' -l en
[ "$(ls -A -- '[output dir]')" = "$EXPECT_DIR_ENTRIES" ]
cmp sentinel "$LITERAL_OUTPUT"
expect_failure 'directory alias through missing parent' 'The output path must refer to an ordinary file' \
    -i "$LITERAL_INPUT" -o 'missing/..' -l en
[ ! -e missing ]
expect_failure 'blocked output directory' 'Failed to save the result' \
    -i "$LITERAL_INPUT" -o 'sentinel/result.json' -l en
cmp sentinel "$LITERAL_OUTPUT"

ln -s "$LITERAL_OUTPUT" symlink-output
expect_failure 'symlink output' 'The output path must refer to an ordinary file' \
    -i "$LITERAL_INPUT" -o symlink-output -l en
[ -L symlink-output ]
cmp sentinel "$LITERAL_OUTPUT"

NAME_LIMIT=$(getconf NAME_MAX "$TEMP_DIR")
TOO_LONG_NAME=$(printf '%0*d' "$((NAME_LIMIT + 1))" 0)
expect_failure 'failed result move' 'Failed to save the result' \
    -i "$LITERAL_INPUT" -o "$TOO_LONG_NAME" -l en
[ ! -e "$TOO_LONG_NAME" ]

MACHINE_OUTPUT=$(bash "$CONVERTER" -i "$LITERAL_INPUT" -o "$LITERAL_OUTPUT" -l en --machine-readable)
EXPECTED_MACHINE_OUTPUT=$(printf 'status=success\nroute_count=3\noutput_path=%s' "$TEMP_DIR/$LITERAL_OUTPUT")
[ "$MACHINE_OUTPUT" = "$EXPECTED_MACHINE_OUTPUT" ]
cmp "$EXPECTED" "$LITERAL_OUTPUT"
assert_no_temp_files

mkdir -p 'physical/child'
ln -s 'physical/child' 'linked child'
MACHINE_OUTPUT=$(bash "$CONVERTER" -i "$LITERAL_INPUT" -o 'linked child/../result.json' -l en --machine-readable)
EXPECTED_MACHINE_OUTPUT=$(printf 'status=success\nroute_count=3\noutput_path=%s' "$TEMP_DIR/physical/result.json")
[ "$MACHINE_OUTPUT" = "$EXPECTED_MACHINE_OUTPUT" ]
cmp "$EXPECTED" physical/result.json
[ ! -e result.json ]
assert_no_temp_files

for INVALID_JSON in \
    'garbage {"hostname":"192.0.2.0/24"} garbage' \
    '[{"hostname":"192.0.2.0/24"}' \
    '[{"hostname":"192.0.2.0/24","value":[1]' \
    '[{"hostname":"192.0.2.0/24"}] garbage' \
    '[{"hostname":"192.0.2.0/24"}],[]' \
    '[{"hostname":"192.0.2.0/24","value":01}]' \
    '[{"hostname":"192.0.2.0/24","value":"\x"}]' \
    '[{"hostname":"192.0.2.0/24","value":"\u123"}]' \
    '[{"hostname":"192.0.2.0/24"},]' \
    '[{"hostname":"192.0.2.0/24",}]'; do
    printf '%s\n' "$INVALID_JSON" > malformed.json
    expect_failure "$INVALID_JSON" 'Invalid input JSON.' -i malformed.json -o "$LITERAL_OUTPUT" -l en
    cmp "$EXPECTED" "$LITERAL_OUTPUT"
done

printf '[{"hostname":"192.0.2.0/24","value":"\001"}]\n' > malformed.json
expect_failure 'unescaped control character' 'Invalid input JSON.' -i malformed.json -o "$LITERAL_OUTPUT" -l en
printf '[{"hostname":"192.0.2.0/24","value":"\300\257"}]\n' > malformed.json
expect_failure 'invalid UTF-8' 'Invalid input JSON.' -i malformed.json -o "$LITERAL_OUTPUT" -l en
cmp "$EXPECTED" "$LITERAL_OUTPUT"

printf '%s\n' '[{"meta":{"hostname":"192.0.2.0/24"}},[{"hostname":"198.51.100.0/24"}],{"hostname":["203.0.113.0/24"]},"{\"hostname\":\"192.0.2.0/24\"}"]' > nested.json
expect_failure 'nested and non-string hostname values' 'No valid CIDR entries were found.' \
    -i nested.json -o absent.json -l en
[ ! -e absent.json ]

printf '\357\273\277' > escaped.json
cat >> escaped.json <<'EOF'
[
  null, false, 4, ["irrelevant"],
  {"note":"{\"hostname\":\"198.51.100.0/24\"}","meta":{"any":[{},[],true,-12.5e+2,"\u00e9","é路😀"]},
   "host\u006eame":"\t142.250.0.0\/15\u0020"},
  {"hostname":"142.250.0.0/15"},
  {"hostname":"1.1.1.0\u002f24","meta":{"hostname":"203.0.113.0/24"}},
  {"hostname":"192.0.2.0/24"}
]
EOF
bash "$CONVERTER" -i escaped.json -o escaped-output.json -l en --machine-readable > escaped-stdout.txt
cmp "$EXPECTED" escaped-output.json

printf '%s\n' '{"hostname":"192.0.2.0/24","meta":{"hostname":"203.0.113.0/24"}}' > object.json
bash "$CONVERTER" -i object.json -o object-output.json -l en --machine-readable > object-stdout.txt
grep -Fxq 'route_count=1' object-stdout.txt
grep -Fq '"ip": "192.0.2.0/24"' object-output.json
assert_no_temp_files

echo 'All Bash tests passed.'
