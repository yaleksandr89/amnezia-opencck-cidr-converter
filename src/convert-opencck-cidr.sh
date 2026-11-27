#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PROJECT_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"
DEFAULT_OUTPUT="$PROJECT_ROOT/amnezia-opencck-cidr.json"
AWK_CONVERTER="$SCRIPT_DIR/lib/convert-opencck-cidr.awk"

SOURCE_URL=""
INPUT_PATH=""
OUTPUT_PATH=""
TEMP_INPUT=""
TEMP_COUNT=""
TEMP_OUTPUT=""
LANGUAGE="auto"
MACHINE_READABLE=0

detect_language() {
    local locale_value
    locale_value=${LC_ALL:-${LC_MESSAGES:-${LANG:-}}}

    case "$locale_value" in
        ru*|RU*) LANGUAGE="ru" ;;
        *) LANGUAGE="en" ;;
    esac
}

set_language() {
    local value
    value=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')

    case "$value" in
        auto)
            detect_language
            ;;
        ru|ru-ru|ru_ru)
            LANGUAGE="ru"
            ;;
        en|en-us|en_us|en-gb|en_gb)
            LANGUAGE="en"
            ;;
        *)
            printf '\nError / Ошибка: unsupported language: %s\n' "$1" >&2
            exit 1
            ;;
    esac
}

message() {
    local key
    key=$1
    shift || true

    case "$LANGUAGE:$key" in
        ru:error) printf 'Ошибка: %s' "$1" ;;
        en:error) printf 'Error: %s' "$1" ;;

        ru:missing_value) printf 'После %s требуется значение.' "$1" ;;
        en:missing_value) printf 'Option %s requires a value.' "$1" ;;

        ru:unknown_option) printf 'Неизвестный параметр: %s' "$1" ;;
        en:unknown_option) printf 'Unknown option: %s' "$1" ;;

        ru:exclusive_inputs) printf 'Параметры --source-url и --input-path нельзя использовать одновременно.' ;;
        en:exclusive_inputs) printf 'Options --source-url and --input-path cannot be used together.' ;;

        ru:url_empty) printf 'Ссылка не введена.' ;;
        en:url_empty) printf 'The URL was not provided.' ;;

        ru:url_host) printf 'Ожидалась HTTPS-ссылка с сайта iplist.opencck.org.' ;;
        en:url_host) printf 'Expected an HTTPS URL from iplist.opencck.org.' ;;

        ru:url_format) printf 'В ссылке не найден параметр format=amnezia.' ;;
        en:url_format) printf 'The URL does not contain format=amnezia.' ;;

        ru:url_data) printf 'В ссылке не найден параметр data=cidr4.' ;;
        en:url_data) printf 'The URL does not contain data=cidr4.' ;;

        ru:url_sites) printf 'В ссылке нет выбранных ресурсов (параметров site=...).' ;;
        en:url_sites) printf 'The URL does not contain selected resources (site=... parameters).' ;;

        ru:download_tool) printf 'Для загрузки списка требуется curl или wget.' ;;
        en:download_tool) printf 'curl or wget is required to download the list.' ;;

        ru:empty_response) printf 'OpenCCK вернул пустой ответ.' ;;
        en:empty_response) printf 'OpenCCK returned an empty response.' ;;

        ru:file_missing) printf 'Входной файл не найден: %s' "$1" ;;
        en:file_missing) printf 'Input file not found: %s' "$1" ;;

        ru:file_empty) printf 'Входной JSON-файл пуст.' ;;
        en:file_empty) printf 'The input JSON file is empty.' ;;

        ru:same_path) printf 'Входной и выходной файлы должны различаться.' ;;
        en:same_path) printf 'Input and output must be different files.' ;;

        ru:output_type) printf 'Путь результата должен указывать на обычный файл: %s' "$1" ;;
        en:output_type) printf 'The output path must refer to an ordinary file: %s' "$1" ;;

        ru:downloading) printf 'Скачиваю актуальный список OpenCCK...\n' ;;
        en:downloading) printf 'Downloading the current OpenCCK list...\n' ;;

        ru:reading_file) printf 'Читаю локальный файл: %s\n' "$1" ;;
        en:reading_file) printf 'Reading local file: %s\n' "$1" ;;

        ru:invalid_cidr_prefix) printf 'Предупреждение: пропущена некорректная IPv4 CIDR-запись: ' ;;
        en:invalid_cidr_prefix) printf 'Warning: skipped invalid IPv4 CIDR entry: ' ;;

        ru:no_valid_routes) printf 'Не удалось получить ни одной корректной CIDR-записи.' ;;
        en:no_valid_routes) printf 'No valid CIDR entries were found.' ;;

        ru:invalid_json) printf 'Некорректный входной JSON.' ;;
        en:invalid_json) printf 'Invalid input JSON.' ;;

        ru:convert_failed) printf 'Не удалось преобразовать входной JSON.' ;;
        en:convert_failed) printf 'Failed to convert the input JSON.' ;;

        ru:output_failed) printf 'Не удалось сохранить результат: %s' "$1" ;;
        en:output_failed) printf 'Failed to save the result: %s' "$1" ;;

        ru:done) printf 'Готово.' ;;
        en:done) printf 'Done.' ;;

        ru:route_count) printf 'Количество маршрутов: %s' "$1" ;;
        en:route_count) printf 'Route count: %s' "$1" ;;

        ru:output_file) printf 'Файл: %s' "$1" ;;
        en:output_file) printf 'File: %s' "$1" ;;

        ru:import_result) printf 'Импортируйте созданный JSON в приложение.' ;;
        en:import_result) printf 'Import the generated JSON into the application.' ;;

        *)
            printf 'Unknown message key: %s' "$key" >&2
            return 1
            ;;
    esac
}

cleanup() {
    if [ -n "$TEMP_INPUT" ] && [ -f "$TEMP_INPUT" ]; then
        rm -f -- "$TEMP_INPUT"
    fi

    if [ -n "$TEMP_COUNT" ] && [ -f "$TEMP_COUNT" ]; then
        rm -f -- "$TEMP_COUNT"
    fi

    if [ -n "$TEMP_OUTPUT" ]; then
        rm -f -- "$TEMP_OUTPUT"
    fi
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

detect_language

fail() {
    printf '\n%s\n' "$(message error "$1")" >&2
    exit 1
}

usage() {
    if [ "$LANGUAGE" = "ru" ]; then
        printf '%s\n' \
            'Использование:' \
            '  convert-opencck-cidr.sh [--source-url URL] [--output-path FILE] [--language LANG] [--machine-readable]' \
            '  convert-opencck-cidr.sh --input-path FILE [--output-path FILE] [--language LANG] [--machine-readable]' \
            '' \
            'Параметры:' \
            '  --source-url, -u   Ссылка OpenCCK' \
            '  --input-path, -i   Локальный JSON в формате OpenCCK' \
            '  --output-path, -o  Путь к результирующему JSON' \
            '  --language, -l     Язык интерфейса: auto, ru или en' \
            '  --machine-readable Машинный формат результата для TUI' \
            '  --help, -h         Показать справку'
    else
        printf '%s\n' \
            'Usage:' \
            '  convert-opencck-cidr.sh [--source-url URL] [--output-path FILE] [--language LANG] [--machine-readable]' \
            '  convert-opencck-cidr.sh --input-path FILE [--output-path FILE] [--language LANG] [--machine-readable]' \
            '' \
            'Options:' \
            '  --source-url, -u   OpenCCK URL' \
            '  --input-path, -i   Local JSON in OpenCCK format' \
            '  --output-path, -o  Output JSON path' \
            '  --language, -l     Interface language: auto, ru, or en' \
            '  --machine-readable Machine-readable result for TUI' \
            '  --help, -h         Show help'
    fi
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --source-url|-u)
            [ "$#" -ge 2 ] || fail "$(message missing_value "$1")"
            SOURCE_URL=$2
            shift 2
            ;;
        --input-path|-i)
            [ "$#" -ge 2 ] || fail "$(message missing_value "$1")"
            INPUT_PATH=$2
            shift 2
            ;;
        --output-path|-o)
            [ "$#" -ge 2 ] || fail "$(message missing_value "$1")"
            OUTPUT_PATH=$2
            shift 2
            ;;
        --language|-l)
            [ "$#" -ge 2 ] || fail "$(message missing_value "$1")"
            set_language "$2"
            shift 2
            ;;
        --machine-readable)
            MACHINE_READABLE=1
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            fail "$(message unknown_option "$1")"
            ;;
    esac
done

if [ -n "$SOURCE_URL" ] && [ -n "$INPUT_PATH" ]; then
    fail "$(message exclusive_inputs)"
fi

if [ -z "$OUTPUT_PATH" ]; then
    OUTPUT_PATH=$DEFAULT_OUTPUT
fi

read_source_url() {
    if [ "$LANGUAGE" = "ru" ]; then
        printf '%s\n' \
            '' \
            '============================================================' \
            ' Конвертер CIDR OpenCCK для AmneziaVPN' \
            '============================================================' \
            '' \
            '1. Откройте: https://iplist.opencck.org/' \
            '2. Выберите нужные ресурсы.' \
            '3. Формат: Amnezia.' \
            '4. Тип данных: IP-зоны IPv4 (CIDR).' \
            '' \
            'ВАЖНО: пункт «Сохранить как файл» должен быть выключен.' \
            'Скопируйте длинную ссылку из нижнего поля страницы.' \
            ''

        printf 'Вставьте ссылку OpenCCK и нажмите Enter: '
    else
        printf '%s\n' \
            '' \
            '============================================================' \
            ' OpenCCK CIDR Converter for AmneziaVPN' \
            '============================================================' \
            '' \
            '1. Open: https://iplist.opencck.org/' \
            '2. Select the required resources.' \
            '3. Format: Amnezia.' \
            '4. Data type: IPv4 CIDR ranges.' \
            '' \
            'IMPORTANT: disable the "Save as file" option.' \
            'Copy the long URL from the field at the bottom of the page.' \
            ''

        printf 'Paste the OpenCCK URL and press Enter: '
    fi

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
    [ -n "$value" ] || fail "$(message url_empty)"

    lower=$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')

    case "$lower" in
        https://iplist.opencck.org|https://iplist.opencck.org/*|https://iplist.opencck.org\?*) ;;
        *) fail "$(message url_host)" ;;
    esac

    printf '%s' "$lower" | grep -Eq '(^|[?&])format=amnezia(&|$)' \
        || fail "$(message url_format)"

    printf '%s' "$lower" | grep -Eq '(^|[?&])data=cidr4(&|$)' \
        || fail "$(message url_data)"

    printf '%s' "$lower" | grep -Eq '(^|[?&])site=[^&]+' \
        || fail "$(message url_sites)"

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
        fail "$(message download_tool)"
    fi

    [ -s "$TEMP_INPUT" ] || fail "$(message empty_response)"
    INPUT_PATH=$TEMP_INPUT
}

if [ -z "$INPUT_PATH" ] && [ -z "$SOURCE_URL" ]; then
    read_source_url
fi

if [ -n "$SOURCE_URL" ]; then
    normalize_and_validate_url "$SOURCE_URL"

    if [ "$MACHINE_READABLE" -eq 0 ]; then
        message downloading
    fi

    download_source
else
    [ -f "$INPUT_PATH" ] || fail "$(message file_missing "$INPUT_PATH")"
    [ ! "$INPUT_PATH" -ef "$OUTPUT_PATH" ] || fail "$(message same_path)"
    [ -s "$INPUT_PATH" ] || fail "$(message file_empty)"

    if [ "$MACHINE_READABLE" -eq 0 ]; then
        message reading_file "$INPUT_PATH"
    fi
fi

case "$OUTPUT_PATH" in
    */|.|..|*/.|*/..) fail "$(message output_type "$OUTPUT_PATH")" ;;
esac
if [ -L "$OUTPUT_PATH" ] || { [ -e "$OUTPUT_PATH" ] && [ ! -f "$OUTPUT_PATH" ]; }; then
    fail "$(message output_type "$OUTPUT_PATH")"
fi

OUTPUT_DIR=$(dirname -- "$OUTPUT_PATH")
mkdir -p -- "$OUTPUT_DIR" || fail "$(message output_failed "$OUTPUT_PATH")"
ABS_OUTPUT_DIR=$(CDPATH= cd -P -- "$OUTPUT_DIR" && pwd -P) \
    || fail "$(message output_failed "$OUTPUT_PATH")"
ABS_OUTPUT="$ABS_OUTPUT_DIR/$(basename -- "$OUTPUT_PATH")"
TEMP_OUTPUT=$(mktemp "$ABS_OUTPUT_DIR/.amnezia-opencck-output.XXXXXX") \
    || fail "$(message output_failed "$OUTPUT_PATH")"
TEMP_COUNT=$(mktemp "${TMPDIR:-/tmp}/amnezia-opencck-count.XXXXXX")

if ! LC_ALL=C AMNEZIA_COUNT_FILE="$TEMP_COUNT" awk \
    -v invalid_cidr_prefix="$(message invalid_cidr_prefix)" \
    -v no_valid_routes="$(message no_valid_routes)" \
    -v invalid_json="$(message invalid_json)" \
    -f "$AWK_CONVERTER" \
    < "$INPUT_PATH" > "$TEMP_OUTPUT"; then
    fail "$(message convert_failed)"
fi

ROUTE_COUNT=$(cat "$TEMP_COUNT")
mv -f -- "$TEMP_OUTPUT" "$OUTPUT_PATH" || fail "$(message output_failed "$OUTPUT_PATH")"
TEMP_OUTPUT=""

if [ "$MACHINE_READABLE" -eq 1 ]; then
    printf 'status=success\n'
    printf 'route_count=%s\n' "$ROUTE_COUNT"
    printf 'output_path=%s\n' "$ABS_OUTPUT"
else
    printf '\n%s\n' "$(message done)"
    printf '%s\n' "$(message route_count "$ROUTE_COUNT")"
    printf '%s\n\n' "$(message output_file "$ABS_OUTPUT")"
    printf '%s\n' "$(message import_result)"
fi
