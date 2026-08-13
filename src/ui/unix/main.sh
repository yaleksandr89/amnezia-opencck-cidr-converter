#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"
CORE_PATH="$SCRIPT_DIR/../../convert-opencck-cidr.sh"

. "$LIB_DIR/messages.sh"
. "$LIB_DIR/dependencies.sh"
. "$LIB_DIR/platform.sh"
. "$LIB_DIR/input.sh"
. "$LIB_DIR/menus.sh"
. "$LIB_DIR/conversion.sh"

if ! test_ui_dependencies "$CORE_PATH"; then
    exit 1
fi

CONVERTER_PATH="$(CDPATH= cd -- "$(dirname -- "$CORE_PATH")" && pwd)/$(basename -- "$CORE_PATH")"

while true; do
    show_main_menu

    case "$MENU_ACTION" in
        Url)
            invoke_conversion_flow Url
            [ "$FLOW_ACTION" != "Exit" ] || exit 0
            ;;
        File)
            invoke_conversion_flow File
            [ "$FLOW_ACTION" != "Exit" ] || exit 0
            ;;
        Language)
            show_language_menu

            if [ "$MENU_ACTION" != "Back" ]; then
                set_ui_language "$MENU_ACTION"
            fi
            ;;
        Exit)
            printf '\n%s\n' "$(ui_text Bye)"
            exit 0
            ;;
    esac
done
