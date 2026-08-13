run_core_conversion() {
    mode=$1
    source=$2
    output_path=$3
    language=$4

    stdout_file=$(mktemp \
        "${TMPDIR:-/tmp}/amnezia-opencck-ui-stdout.XXXXXX")
    stderr_file=$(mktemp \
        "${TMPDIR:-/tmp}/amnezia-opencck-ui-stderr.XXXXXX")

    set +e
    if [ "$mode" = "Url" ]; then
        bash "$CONVERTER_PATH" \
            --source-url "$source" \
            --output-path "$output_path" \
            --language "$language" \
            --machine-readable \
            >"$stdout_file" 2>"$stderr_file"
    else
        bash "$CONVERTER_PATH" \
            --input-path "$source" \
            --output-path "$output_path" \
            --language "$language" \
            --machine-readable \
            >"$stdout_file" 2>"$stderr_file"
    fi
    core_status=$?
    set -e

    CONVERSION_SUCCESS=0
    CONVERSION_ROUTE_COUNT=0
    CONVERSION_OUTPUT_PATH=$output_path
    CONVERSION_ERROR=""

    if [ "$core_status" -eq 0 ]; then
        result_status=$(sed -n 's/^status=//p' "$stdout_file")
        route_count=$(sed -n 's/^route_count=//p' "$stdout_file")
        result_path=$(sed -n 's/^output_path=//p' "$stdout_file")

        if [ "$result_status" = "success" ] \
            && [ -n "$route_count" ] \
            && [ -n "$result_path" ]; then
            CONVERSION_SUCCESS=1
            CONVERSION_ROUTE_COUNT=$route_count
            CONVERSION_OUTPUT_PATH=$result_path
        else
            CONVERSION_ERROR=$(ui_text InvalidMachineResult)
        fi
    else
        CONVERSION_ERROR=$(cat "$stderr_file")
    fi

    rm -f -- "$stdout_file" "$stderr_file"
}

invoke_conversion_flow() {
    mode=$1
    FLOW_ACTION="MainMenu"

    printf '\n'

    if ! read_source_value "$mode"; then
        return
    fi
    source=$INPUT_VALUE

    while true; do
        if ! select_output_directory; then
            return
        fi

        output_directory=$OUTPUT_DIRECTORY
        output_path="$output_directory/amnezia-opencck-cidr.json"

        if [ "$mode" = "Url" ]; then
            source_label=$(ui_text SourceUrl)
        else
            source_label=$(ui_text SourceFile)
        fi

        printf '\n%s\n%s\n\n%s\n%s\n' \
            "$source_label" \
            "$source" \
            "$(ui_text Output)" \
            "$output_path"

        if ! confirmation=$(gum choose \
            --header "$(ui_text CheckParameters)" \
            "$(ui_text Run)" \
            "$(ui_text Back)" \
            "$(ui_text Cancel)"); then
            return
        fi

        if [ "$confirmation" = "$(ui_text Back)" ]; then
            continue
        fi

        if [ "$confirmation" = "$(ui_text Cancel)" ]; then
            printf '\n%s\n' "$(ui_text Cancelled)"
            return
        fi

        while true; do
            run_core_conversion \
                "$mode" \
                "$source" \
                "$output_path" \
                "$(get_ui_language)"

            printf '\n'

            if [ "$CONVERSION_SUCCESS" -eq 1 ]; then
                printf '%s\n\n' "$(ui_text Success)"
                printf '%s: %s\n' \
                    "$(ui_text Routes)" \
                    "$CONVERSION_ROUTE_COUNT"
                printf '%s: %s\n\n' \
                    "$(ui_text File)" \
                    "$CONVERSION_OUTPUT_PATH"

                show_success_menu "$output_directory"
                FLOW_ACTION=$MENU_ACTION
                return
            fi

            printf '%s\n\n' "$(ui_text Failed)"
            printf '%s\n\n' "$CONVERSION_ERROR"

            show_error_menu "$mode"

            case "$MENU_ACTION" in
                EditSource)
                    if ! read_source_value "$mode" "$source"; then
                        FLOW_ACTION="MainMenu"
                        return
                    fi
                    source=$INPUT_VALUE
                    ;;
                ChangeOutput)
                    break
                    ;;
                MainMenu)
                    FLOW_ACTION="MainMenu"
                    return
                    ;;
                Exit)
                    FLOW_ACTION="Exit"
                    return
                    ;;
            esac
        done
    done
}
