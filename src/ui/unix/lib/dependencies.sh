test_ui_dependencies() {
    core_path=$1
    has_errors=0

    if ! command -v gum >/dev/null 2>&1; then
        printf '\n%s\n\n' "$(ui_text DependencyFailed)"
        printf '%s\n' "$(ui_text GumMissing)"
        printf '%s\n' "$(ui_text GumMissingHint)"
        has_errors=1
    fi

    if [ ! -f "$core_path" ]; then
        if [ "$has_errors" -eq 0 ]; then
            printf '\n%s\n\n' "$(ui_text DependencyFailed)"
        fi

        printf '%s\n' "$(ui_text CoreMissing)"
        printf '%s\n' "$core_path"
        has_errors=1
    fi

    [ "$has_errors" -eq 0 ]
}
