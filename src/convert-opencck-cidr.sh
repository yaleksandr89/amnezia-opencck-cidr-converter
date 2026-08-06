#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PROJECT_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"
DEFAULT_OUTPUT="$PROJECT_ROOT/amnezia-opencck-cidr.json"

SOURCE_URL=""
INPUT_PATH=""
OUTPUT_PATH=""
TEMP_INPUT=""
TEMP_COUNT=""

cleanup() {
    if [ -n "$TEMP_INPUT" ] && [ -f "$TEMP_INPUT" ]; then
        rm -f -- "$TEMP_INPUT"
    fi
    if [ -n "$TEMP_COUNT" ] && [ -f "$TEMP_COUNT" ]; then
        rm -f -- "$TEMP_COUNT"
    fi
}
trap cleanup EXIT HUP INT TERM

fail() {
    printf '\nОшибка: %s\n' "$1" >&2
    exit 1
}

usage() {
    cat <<'USAGE'
Использование:
  convert-opencck-cidr.sh [--source-url URL] [--output-path FILE]
  convert-opencck-cidr.sh --input-path FILE [--output-path FILE]

Параметры:
  --source-url, -u   Ссылка OpenCCK
  --input-path, -i   Локальный JSON в формате OpenCCK
  --output-path, -o  Путь к результирующему JSON
  --help, -h         Показать справку
USAGE
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --source-url|-u)
            [ "$#" -ge 2 ] || fail "После $1 требуется значение."
            SOURCE_URL=$2
            shift 2
            ;;
        --input-path|-i)
            [ "$#" -ge 2 ] || fail "После $1 требуется значение."
            INPUT_PATH=$2
            shift 2
            ;;
        --output-path|-o)
            [ "$#" -ge 2 ] || fail "После $1 требуется значение."
            OUTPUT_PATH=$2
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            fail "Неизвестный параметр: $1"
            ;;
    esac
done

if [ -n "$SOURCE_URL" ] && [ -n "$INPUT_PATH" ]; then
    fail "Параметры --source-url и --input-path нельзя использовать одновременно."
fi

if [ -z "$OUTPUT_PATH" ]; then
    OUTPUT_PATH=$DEFAULT_OUTPUT
fi

read_source_url() {
    cat <<'MESSAGE'

============================================================
 Конвертер CIDR OpenCCK для AmneziaVPN
============================================================

1. Откройте: https://iplist.opencck.org/
2. Выберите нужные ресурсы.
3. Формат: Amnezia.
4. Тип данных: IP-зоны IPv4 (CIDR).

ВАЖНО: пункт «Сохранить как файл» должен быть выключен.
Скопируйте длинную ссылку из нижнего поля страницы.

MESSAGE
    printf 'Вставьте ссылку OpenCCK и нажмите Enter: '
    IFS= read -r SOURCE_URL
}

normalize_and_validate_url() {
    local value lower
    value=$1

    value=$(printf '%s' "$value" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

    case "$value" in
        \"*\") value=${value#\"}; value=${value%\"} ;;
        \'*\') value=${value#\'}; value=${value%\'} ;;
    esac

    value=$(printf '%s' "$value" | sed 's/&amp;/\&/g')
    [ -n "$value" ] || fail "Ссылка не введена."

    lower=$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')

    case "$lower" in
        https://iplist.opencck.org|https://iplist.opencck.org/*|https://iplist.opencck.org\?*) ;;
        *) fail "Ожидалась HTTPS-ссылка с сайта iplist.opencck.org." ;;
    esac

    printf '%s' "$lower" | grep -Eq '(^|[?&])format=amnezia(&|$)' \
        || fail "В ссылке не найден параметр format=amnezia."

    printf '%s' "$lower" | grep -Eq '(^|[?&])data=cidr4(&|$)' \
        || fail "В ссылке не найден параметр data=cidr4."

    printf '%s' "$lower" | grep -Eq '(^|[?&])site=[^&]+' \
        || fail "В ссылке нет выбранных ресурсов (параметров site=...)."

    SOURCE_URL=$value
}

download_source() {
    TEMP_INPUT=$(mktemp "${TMPDIR:-/tmp}/amnezia-opencck-input.XXXXXX")

    if command -v curl >/dev/null 2>&1; then
        curl --fail --location --silent --show-error --max-time 120 \
            --output "$TEMP_INPUT" "$SOURCE_URL"
    elif command -v wget >/dev/null 2>&1; then
        wget --quiet --timeout=120 --output-document="$TEMP_INPUT" "$SOURCE_URL"
    else
        fail "Для загрузки списка требуется curl или wget."
    fi

    [ -s "$TEMP_INPUT" ] || fail "OpenCCK вернул пустой ответ."
    INPUT_PATH=$TEMP_INPUT
}

if [ -z "$INPUT_PATH" ] && [ -z "$SOURCE_URL" ]; then
    read_source_url
fi

if [ -n "$SOURCE_URL" ]; then
    normalize_and_validate_url "$SOURCE_URL"
    printf 'Скачиваю актуальный список OpenCCK...\n'
    download_source
else
    [ -f "$INPUT_PATH" ] || fail "Входной файл не найден: $INPUT_PATH"
    [ -s "$INPUT_PATH" ] || fail "Входной JSON-файл пуст."
    printf 'Читаю локальный файл: %s\n' "$INPUT_PATH"
fi

OUTPUT_DIR=$(dirname -- "$OUTPUT_PATH")
mkdir -p -- "$OUTPUT_DIR"
TEMP_COUNT=$(mktemp "${TMPDIR:-/tmp}/amnezia-opencck-count.XXXXXX")

set +e
awk -v count_file="$TEMP_COUNT" '
function is_ipv4_cidr(value, parts, address, prefix, octets, i) {
    if (value !~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/[0-9]+$/) {
        return 0
    }

    split(value, parts, "/")
    address = parts[1]
    prefix = parts[2] + 0

    if (prefix < 0 || prefix > 32 || parts[2] !~ /^[0-9]+$/) {
        return 0
    }

    if (split(address, octets, ".") != 4) {
        return 0
    }

    for (i = 1; i <= 4; i++) {
        if (octets[i] !~ /^[0-9]+$/ || octets[i] + 0 < 0 || octets[i] + 0 > 255) {
            return 0
        }
    }

    return 1
}

function finish_string() {
    if (string_role == "key") {
        current_key = token
        state = "after_key"
    } else if (string_role == "value") {
        if (current_key == "hostname") {
            cidr = token
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", cidr)

            if (cidr != "") {
                if (!is_ipv4_cidr(cidr)) {
                    print "Предупреждение: пропущена некорректная IPv4 CIDR-запись: " cidr > "/dev/stderr"
                } else if (!(tolower(cidr) in seen)) {
                    count++
                    seen[tolower(cidr)] = 1
                    routes[count] = cidr
                }
            }
        }
        state = "after_value"
    }

    token = ""
    string_role = ""
}

BEGIN {
    state = "search_key"
    in_string = 0
    escape = 0
    token = ""
    count = 0
}

{
    line = $0 "\n"

    for (i = 1; i <= length(line); i++) {
        c = substr(line, i, 1)

        if (in_string) {
            if (escape) {
                token = token c
                escape = 0
            } else if (c == "\\") {
                escape = 1
            } else if (c == "\"") {
                in_string = 0
                finish_string()
            } else {
                token = token c
            }
            continue
        }

        if (state == "search_key") {
            if (c == "\"") {
                in_string = 1
                string_role = "key"
                token = ""
            }
        } else if (state == "after_key") {
            if (c ~ /[[:space:]]/) {
                continue
            }
            if (c == ":") {
                state = "before_value"
            } else {
                state = "search_key"
            }
        } else if (state == "before_value") {
            if (c ~ /[[:space:]]/) {
                continue
            }
            if (c == "\"") {
                in_string = 1
                string_role = "value"
                token = ""
            } else {
                state = "after_value"
            }
        } else if (state == "after_value") {
            if (c == "," || c == "}") {
                state = "search_key"
                current_key = ""
            }
        }
    }
}

END {
    if (count == 0) {
        print "Не удалось получить ни одной корректной CIDR-записи." > "/dev/stderr"
        exit 42
    }

    print "["
    for (i = 1; i <= count; i++) {
        print "  {"
        printf "    \"hostname\": \"route-%06d.invalid\",\n", i
        printf "    \"ip\": \"%s\"\n", routes[i]
        if (i < count) {
            print "  },"
        } else {
            print "  }"
        }
    }
    print "]"
    print count > count_file
}
' "$INPUT_PATH" > "$OUTPUT_PATH"
AWK_STATUS=$?
set -e

if [ "$AWK_STATUS" -ne 0 ]; then
    rm -f -- "$OUTPUT_PATH"
    fail "Не удалось преобразовать входной JSON."
fi

ROUTE_COUNT=$(cat "$TEMP_COUNT")
ABS_OUTPUT_DIR=$(CDPATH= cd -- "$(dirname -- "$OUTPUT_PATH")" && pwd)
ABS_OUTPUT="$ABS_OUTPUT_DIR/$(basename -- "$OUTPUT_PATH")"

printf '\nГотово.\n'
printf 'Количество маршрутов: %s\n' "$ROUTE_COUNT"
printf 'Файл: %s\n' "$ABS_OUTPUT"
printf 'Импортируйте созданный JSON в приложение.\n'
