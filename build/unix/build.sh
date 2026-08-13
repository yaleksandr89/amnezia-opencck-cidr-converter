#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PROJECT_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)"

GUM_VERSION="0.17.0"
CHECKSUMS_NAME="checksums.txt"
CHECKSUMS_SHA256="daf9b5a189631771edf2364ad239862aa120b43a62ed7b5e501d1478b031db78"

PLATFORM=$(uname -s)
ARCHITECTURE=$(uname -m)

case "$PLATFORM:$ARCHITECTURE" in
    Linux:x86_64)
        PACKAGE_PLATFORM="linux_x64"
        GUM_ARCHIVE_NAME="gum_${GUM_VERSION}_Linux_x86_64.tar.gz"
        ;;
    Darwin:arm64)
        PACKAGE_PLATFORM="macos_arm64"
        GUM_ARCHIVE_NAME="gum_${GUM_VERSION}_Darwin_arm64.tar.gz"
        ;;
    *)
        printf 'Unsupported build platform: %s %s\n' "$PLATFORM" "$ARCHITECTURE" >&2
        exit 1
        ;;
esac

RELEASE_BASE_URL="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}"
CACHE_DIRECTORY="$SCRIPT_DIR/cache"
CHECKSUMS_PATH="$CACHE_DIRECTORY/$CHECKSUMS_NAME"
GUM_ARCHIVE_PATH="$CACHE_DIRECTORY/$GUM_ARCHIVE_NAME"

DIST_DIRECTORY="$PROJECT_ROOT/dist"
PACKAGE_NAME="amnezia-opencck-cidr-converter_${PACKAGE_PLATFORM}"
PACKAGE_DIRECTORY="$DIST_DIRECTORY/$PACKAGE_NAME"
RUNTIME_DIRECTORY="$PACKAGE_DIRECTORY/runtime"
RUNTIME_SOURCE_DIRECTORY="$RUNTIME_DIRECTORY/src"
ARCHIVE_PATH="$DIST_DIRECTORY/${PACKAGE_NAME}.tar.gz"

TEMP_DIRECTORY=$(mktemp -d "${TMPDIR:-/tmp}/amnezia-opencck-build.XXXXXX")

cleanup() {
    rm -rf -- "$TEMP_DIRECTORY"
}
trap cleanup EXIT HUP INT TERM

hash_file() {
    file_path=$1

    case "$PLATFORM" in
        Linux)
            sha256sum "$file_path" | awk '{print $1}'
            ;;
        Darwin)
            shasum -a 256 "$file_path" | awk '{print $1}'
            ;;
    esac
}

download_file() {
    url=$1
    destination=$2

    curl \
        --location \
        --fail \
        --retry 3 \
        --retry-delay 2 \
        --output "$destination" \
        "$url"
}

for required_command in curl tar awk find cmp; do
    if ! command -v "$required_command" >/dev/null 2>&1; then
        printf 'Required build command was not found: %s\n' "$required_command" >&2
        exit 1
    fi
done

if [ "$PLATFORM" = "Linux" ] && ! command -v sha256sum >/dev/null 2>&1; then
    printf 'Required build command was not found: sha256sum\n' >&2
    exit 1
fi

if [ "$PLATFORM" = "Darwin" ] && ! command -v shasum >/dev/null 2>&1; then
    printf 'Required build command was not found: shasum\n' >&2
    exit 1
fi

rm -rf -- "$PACKAGE_DIRECTORY"
rm -f -- "$ARCHIVE_PATH"

mkdir -p \
    "$RUNTIME_SOURCE_DIRECTORY/lib" \
    "$RUNTIME_SOURCE_DIRECTORY/ui" \
    "$CACHE_DIRECTORY"

if [ -f "$CHECKSUMS_PATH" ]; then
    checksums_hash=$(hash_file "$CHECKSUMS_PATH")

    if [ "$checksums_hash" != "$CHECKSUMS_SHA256" ]; then
        printf 'Cached checksum manifest is invalid. Downloading again.\n'
        rm -f -- "$CHECKSUMS_PATH"
    fi
fi

if [ ! -f "$CHECKSUMS_PATH" ]; then
    printf 'Downloading gum %s checksum manifest...\n' "$GUM_VERSION"

    checksums_download="$TEMP_DIRECTORY/$CHECKSUMS_NAME"
    download_file \
        "$RELEASE_BASE_URL/$CHECKSUMS_NAME" \
        "$checksums_download"

    checksums_hash=$(hash_file "$checksums_download")

    if [ "$checksums_hash" != "$CHECKSUMS_SHA256" ]; then
        printf 'gum checksum manifest SHA-256 mismatch.\nExpected: %s\nActual:   %s\n' \
            "$CHECKSUMS_SHA256" \
            "$checksums_hash" >&2
        exit 1
    fi

    mv "$checksums_download" "$CHECKSUMS_PATH"
fi

GUM_SHA256=$(awk -v archive="$GUM_ARCHIVE_NAME" \
    '$2 == archive { print $1; exit }' \
    "$CHECKSUMS_PATH")

if [ -z "$GUM_SHA256" ]; then
    printf 'Checksum for %s was not found.\n' "$GUM_ARCHIVE_NAME" >&2
    exit 1
fi

gum_archive_is_valid=0

if [ -f "$GUM_ARCHIVE_PATH" ]; then
    printf 'Checking cached gum %s...\n' "$GUM_VERSION"
    cached_hash=$(hash_file "$GUM_ARCHIVE_PATH")

    if [ "$cached_hash" = "$GUM_SHA256" ]; then
        printf 'Using cached gum archive.\n'
        gum_archive_is_valid=1
    else
        printf 'Cached gum archive is invalid. Downloading again.\n'
        rm -f -- "$GUM_ARCHIVE_PATH"
    fi
fi

if [ "$gum_archive_is_valid" -eq 0 ]; then
    printf 'Downloading gum %s...\n' "$GUM_VERSION"

    gum_download="$TEMP_DIRECTORY/$GUM_ARCHIVE_NAME"
    download_file \
        "$RELEASE_BASE_URL/$GUM_ARCHIVE_NAME" \
        "$gum_download"

    downloaded_hash=$(hash_file "$gum_download")

    if [ "$downloaded_hash" != "$GUM_SHA256" ]; then
        printf 'gum SHA-256 mismatch.\nExpected: %s\nActual:   %s\n' \
            "$GUM_SHA256" \
            "$downloaded_hash" >&2
        exit 1
    fi

    mv "$gum_download" "$GUM_ARCHIVE_PATH"
fi

printf 'Copying runtime...\n'

cp "$PROJECT_ROOT/src/convert-opencck-cidr.sh" \
    "$RUNTIME_SOURCE_DIRECTORY/"

cp "$PROJECT_ROOT/src/convert-opencck-cidr-ui.sh" \
    "$RUNTIME_SOURCE_DIRECTORY/"

cp "$PROJECT_ROOT/src/lib/convert-opencck-cidr.awk" \
    "$RUNTIME_SOURCE_DIRECTORY/lib/"

cp -R "$PROJECT_ROOT/src/ui/unix" \
    "$RUNTIME_SOURCE_DIRECTORY/ui/"

cp "$SCRIPT_DIR/launcher.sh" \
    "$PACKAGE_DIRECTORY/amnezia-opencck-cidr-converter"

cp "$PROJECT_ROOT/LICENSE" \
    "$PACKAGE_DIRECTORY/"

mkdir -p "$PACKAGE_DIRECTORY/THIRD_PARTY_LICENSES"

cp "$PROJECT_ROOT/build/windows/third-party/GUM-LICENSE.txt" \
    "$PACKAGE_DIRECTORY/THIRD_PARTY_LICENSES/"

chmod +x \
    "$PACKAGE_DIRECTORY/amnezia-opencck-cidr-converter" \
    "$RUNTIME_SOURCE_DIRECTORY/convert-opencck-cidr.sh" \
    "$RUNTIME_SOURCE_DIRECTORY/convert-opencck-cidr-ui.sh" \
    "$RUNTIME_SOURCE_DIRECTORY/ui/unix/main.sh"

gum_extract_directory="$TEMP_DIRECTORY/gum"
mkdir -p "$gum_extract_directory"

tar -xzf "$GUM_ARCHIVE_PATH" \
    -C "$gum_extract_directory"

gum_binary=$(find "$gum_extract_directory" -type f -name gum | sed -n '1p')

if [ -z "$gum_binary" ]; then
    printf 'gum binary was not found in the downloaded archive.\n' >&2
    exit 1
fi

cp "$gum_binary" "$RUNTIME_DIRECTORY/gum"
chmod +x "$RUNTIME_DIRECTORY/gum"

printf 'Validating package runtime...\n'

"$RUNTIME_DIRECTORY/gum" --version >/dev/null

bash -n "$PACKAGE_DIRECTORY/amnezia-opencck-cidr-converter"
bash -n "$RUNTIME_SOURCE_DIRECTORY/convert-opencck-cidr.sh"
bash -n "$RUNTIME_SOURCE_DIRECTORY/convert-opencck-cidr-ui.sh"
bash -n "$RUNTIME_SOURCE_DIRECTORY/ui/unix/main.sh"

for runtime_library in "$RUNTIME_SOURCE_DIRECTORY"/ui/unix/lib/*.sh; do
    bash -n "$runtime_library"
done

smoke_output="$TEMP_DIRECTORY/smoke-result.json"

machine_output=$(bash "$RUNTIME_SOURCE_DIRECTORY/convert-opencck-cidr.sh" \
    --input-path "$PROJECT_ROOT/tests/fixtures/opencck-sample.json" \
    --output-path "$smoke_output" \
    --language en \
    --machine-readable \
    2>"$TEMP_DIRECTORY/smoke-stderr.txt")

printf '%s\n' "$machine_output" | grep -q '^status=success$'
printf '%s\n' "$machine_output" | grep -q '^route_count=3$'

cmp -s \
    "$PROJECT_ROOT/tests/fixtures/expected-output.json" \
    "$smoke_output"

printf 'Creating release archive...\n'

COPYFILE_DISABLE=1 tar -czf "$ARCHIVE_PATH" \
    -C "$DIST_DIRECTORY" \
    "$PACKAGE_NAME"

printf '\nUnix package created successfully.\n'
printf 'Directory: %s\n' "$PACKAGE_DIRECTORY"
printf 'Archive: %s\n' "$ARCHIVE_PATH"
